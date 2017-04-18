#!/usr/bin/perl -w
$|=1;
use strict;
use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

#use constant BUFFER_SIZE => 16_384;

my $query = new CGI;
print $query->header('text/html;charset=UTF-8');

# readform.cgi
# decode form data
# POST method
#
# Create a page with notification 
# how long it is going to take

my $hostname="http://phenotypelinks.net";

# session directory
my $sessiondir="/var/www/html/browse/sessions/";
my $session_name=$$."_".localtime;
$session_name=~s/\s+/_/g;
$session_name=~s/\:/-/g;
my $progress_file=$session_name."PR\.html";
my $progress_path=$sessiondir.$progress_file;
my $progress_url="$hostname/browse/sessions/".$progress_file;
my $sessionhtml=$sessiondir.$session_name."\.html";

my %ses_pars;
######################################################
# SECTION TO PREPARE PARAMETERS 
# parameters are transformed and stored 
# in hash %ses_pars
print "<p>Your query:<hr>\n";

#######################################################
# mesh
#######################################################
my $mesh = $query->param('mesh');

# validity check
if( length($mesh)<3){
    print "NO PHENOTYPE TERM IS SUBMITTED.STOP.<br>\n";  
    exit(1);
}
$mesh=~s/(\w+)/\u$1/g;
$mesh=~s/\s+/_/g;
$mesh=~s/_$//;
$ses_pars{"mesh"}=$mesh;
print "Mesh term : $mesh<br>\n";
#######################################################
# organism
#######################################################
$ses_pars{"organism"}=$query->param('organism');
print "Organism : $ses_pars{'organism'}<br>\n";
#######################################################
# homology
#######################################################
if ( length($query->param('homology'))>0)
 {$ses_pars{"homology"}=1;}
else {$ses_pars{"homology"}=0;}
print "Homology : $ses_pars{'homology'}<br>\n";
#######################################################
# fast processing
#######################################################
if ( length($query->param('fast'))>0)
 {$ses_pars{"fast"}=1;
  $ses_pars{"dfrac"}=0.01; 
  $ses_pars{"gofrac"}=0.04;}
else 
  {$ses_pars{"fast"}=0;
   $ses_pars{"dfrac"}=0.001; 
   $ses_pars{"gofrac"}=0.01;}
print "Processing parameters<br>\n";
print "&nbsp&nbsp dfrac : $ses_pars{'dfrac'}<br>\n";
print "&nbsp&nbsp gofrac : $ses_pars{'gofrac'}<br>\n";


#######################################################
# KNOWN GENES SECTION 
# genes from file and from symbols if supplied
# are concatenated
#######################################################
my @known_genes_f;
my @known_genes_s;

print "Known genes input<br>\n";
if( length($query->param('known_genes_file'))>0){
#######################################################
# known_genes_file
########################################################
  $ses_pars{"file_known_genes"}=$query->param('known_genes_file');

  my $FH = $query->upload('known_genes_file');
  while (<$FH>){chop; $_=~s/\r//g; push(@known_genes_f,$_);}

  my $n=scalar @known_genes_f;
  print "&nbsp&nbsp File name : $ses_pars{'file_known_genes'}<br>\n";
  print "&nbsp&nbsp #Genes in file : $n<br>\n";
}
else { $ses_pars{"file_known_genes"}=0; } 
#########################################################
# known_genes_symb
#######################################################
if( length($query->param('known_genes_symb'))>0){
my $known_genes_symb = $query->param('known_genes_symb');
@known_genes_s = split(" ",$known_genes_symb);
print "&nbsp&nbsp Genes in textbox : $known_genes_symb<br>\n";
    }

# join known genes lists
if( (scalar @known_genes_f)+(scalar @known_genes_s) >0 ){
    $ses_pars{"known_genes"}=join(",",@known_genes_f,@known_genes_s);}
else { $ses_pars{"known_genes"}="";}

my $n= scalar split(",",$ses_pars{'known_genes'});
print "&nbsp&nbsp Total genes : $n<br>\n";

print "Candidate genes input<br>\n";
#######################################################
# SCORE GENES SECTION 
# this section is identical to the previous only
# it is for genes that are scored 
# are concatenated
#######################################################
my @score_genes_f;
my @score_genes_s;
if( length($query->param('score_genes_file'))>0){
#######################################################
# score_genes_file
########################################################
  $ses_pars{"file_score_genes"}=$query->param('score_genes_file');

  my $FH = $query->upload('score_genes_file');
  while (<$FH>){ chop; $_=~s/\r//g; push(@score_genes_f,$_);}

  my $n=scalar @score_genes_f;
  print "&nbsp&nbsp File name : $ses_pars{'file_score_genes'}<br>\n";
  print "&nbsp&nbsp #Genes in file : $n<br>\n";
}
else { $ses_pars{"file_score_genes"}=0; } 
#########################################################
# score_genes_symb
#######################################################
if( length($query->param('score_genes_symb'))>0){
my $score_genes_symb = $query->param('score_genes_symb');
@score_genes_s = split(" ",$score_genes_symb);
print "&nbsp&nbsp Genes in textbox : $score_genes_symb<br>\n";
    }

# join SCORE genes lists
if( (scalar @score_genes_f)+(scalar @score_genes_s) >0 ){
    $ses_pars{"score_genes"}=join(",",@score_genes_f,@score_genes_s);}
else { $ses_pars{"score_genes"}="";}

my $n= scalar split(",",$ses_pars{'score_genes'});
print "&nbsp&nbsp Total genes : $n<br>\n";

#########################################################
# progress_path    Do we need it ?
#######################################################
$ses_pars{"progress_path"}=$progress_path;

print "</p>\n";
#########################################################
# WRITE SESSION PARAMETERS TO THE DISK
#######################################################
my @query_lines;
my %query_info=("mesh_term"=>"mesh ","gofrac"=>"gofrac","dfrac"=>"dfrac","homology"=>"homology","organism"=>"organism","known_genes"=>"known_genes");

my $session=$sessiondir.$session_name."\.ses";
open(SES,">$session") or print "can't write session $session <br>\n";
foreach my $par( keys %ses_pars)
{ print SES join("=",$par,$ses_pars{$par}),"\n";
  if ( exists $query_info{$par} ){ ## why I need query lines?
     push @query_lines, join(" : ",$query_info{$par},$ses_pars{$par});} }
close(SES); 

#########################################################
# START PROCESSING 
#########################################################
my ($second,$minute,$hour, $dayOfMonth, $month, @rest) = localtime();
my $timedata=join(':',$hour,$minute,$second);
print "Started processing $timedata<br>\n";
print "Average processing time is about 5 minutes, but some queries may take much longer. The link to the results will be printed on this page <hr>\n";

# call qdb3.pl  
# All output from qdb3.pl is printed on that page
system("perl /usr/lib/cgi-bin/qdb3.pl $session_name"); 

my $rez_line="$hostname/browse/sessions/$session_name.html";
print "<hr><p>Your results are ready <a href=\"$rez_line\"> here </a> </p>\n";

print $query->end_html;
exit(0);
