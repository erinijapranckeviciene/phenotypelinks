#!/usr/bin/perl
use strict;
require "include3.pl";

my $meshurl1="http://www.nlm.nih.gov/cgi/mesh/2012/MB_cgi?mode=\&term=";
my $meshurl2="\&field=entry";
########################## Tables from 
my $dat=shift;
my $id=shift;

my $evgomaxline;
my $evgomaxheader;
my $evdline;
my $evdheader;
my $queryline;


open(DAT,"<$dat") || die print "<p> err $dat $! </p>";

while(<DAT>)
{ chop;
  my($lid,$tot,$showing,$info)=split("\t",$_);
 # print $lid,"\n";
  if ($lid eq "EV_GOMAX") 
     {$evgomaxline=$info;
      $evgomaxheader="Total GO terms ".$tot;
     
      }
   if ($lid eq "EV_D")
   { $evdline=$info;
     $evdheader="Total MeSH D Terms ".$tot;
   } 
   if ($lid eq "QUERY_PAGE")
   { $queryline=$tot;
   } 

}
close(DAT);

################## THE DATA IS IN.#########################


my %results_section=( 
"page_title"  =>"Page title",
"title"       =>"Title",
"query"       =>"Phenotype,organism,homology,context genes",
"description" =>"Description what is on the page",
"description_d" =>"Description of the section for D",
"description_go" =>"Description of the section for GO",
"table_d_link"      =>"callproc.cgi?program=d_table.pl&data=sessions/test.dat&ident=EV_D",
"table_go_link"      =>"callproc.cgi?program=go_table.pl&data=sessions/test.dat&ident=EV_GOMAX"

);

$results_section{"evgomaxheader"}=$evgomaxheader;
$results_section{"evdheader"}=$evdheader;
######## Header bar
$results_section{"title"}="<span class=\"alternate_colour\">Phenotype Links </span> tool";

######### Title of the page
my $phenotype=$id;
$results_section{"page_title"}="Evidence_$id";

######### Description of the page
my $tomesh=$phenotype;
$phenotype=~s/_/ /g;
$tomesh=~s/_/+/g;
    my $tomeshref=$meshurl1.$tomesh.$meshurl2;
    my $tomeshpart="<a href=\"$tomeshref\" target=_blank> <font  color=\"#A2AB3B\"> $phenotype </font></a>";
$results_section{"description"}=" Links for <span class=\"alternate_colour\">Phenotype $tomeshpart </span> derived from literature";
######## Query
$results_section{"query"}=$queryline;

$results_section{"description_d"}="<p> MeSH D terms</p>";
$results_section{"description_go"}="<p> GO Terms </p>";
# description of what we have in this window
$results_section{"what_is_on_page"}="<p>The GO annotations most connected  to the phenotype <font style=\"color:brown;\">$phenotype</font> with the  maximum Scores are on the right. The list of the MeSH D terms (Drugs and Chemicals) that have strongest links  to the phenotype <font style=\"color:brown;\">$phenotype</font> and their scores are shown on the left.  Click on <font style=\"color:blue;\">  <<  </font> to examine articles, which led to for $phenotype-MeSH D Term score.Click on the MeSH D Term to see a description of the Term in Medical Subject Headings database. Click on the GO Term to examine it in the Gene Ontology. To find out which GO Terms are linked to the MeSH D terms and vice versa click on <font style=\"color:blue;\"> v </font>. Find more in the <a href=\"http://phenotypelinks.net/browse/userManual.php#evidence_literature\" target=_blank> <font style=\"color:#A2AB3B;\">User Manual </font></a></p>";

# mterm is passed to go_table, to query linked dterms
# changed phenotype in $id instead of $dat
my @gotable=&go_table($evgomaxline,$id);

my @dtable=&d_table($evdline,$id,$dat);


$results_section{"table_d"}=\@dtable;
$results_section{"table_go"}=\@gotable;
$results_section{"data_file"}=$dat;

&print_ev_literature(\%results_section);

sub print_ev_literature{

    my ($ref1)=@_;
    my %re=%$ref1;

#sections
    my $page_title  =$re{"page_title"};
    my $title       =$re{"title"};
    my $query       =$re{"query"};
    my $description =$re{"description"};
    my $description_d =$re{"description_d"};
    my $description_go =$re{"description_go"};
    my $explanation  =$re{"what_is_on_page"};

my $evgh=$re{"evgomaxheader"};
my $evdh=$re{"evdheader"};


my $dref=$re{"table_d"};
    my @table_d       =@$dref;
my $goref=$re{"table_go"};
    my @table_go      =@$goref;

print "<head>";
print "<title>$page_title</title>";

print "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css\">";

print "</head>";
print "<html>";
print "<body>";
print "<div id=\"main\" style=\"margin-bottom:0;\">";
print "<h1>$description</h1>";
print "</div>";
print "<div id=\"page_results\">";
print "<p>$explanation</p>";
print "<hr>";     

print "<table width=\"95%\" cellspacing=\"0\" cellpadding=\"0\" >";
print "<tr>";
print "<td width=\"45%\">";

print "<div style=\"width=100%;height:350px;vertical-align:top;overflow:auto;margin:0\" >";
    print join(" ",@table_d);
    print "</div>";
print "</td>";
    print "<td width=\"55%\">";
print "<div style=\"width=100%;height:350px;vertical-align:top;overflow:auto;\" >";

    print join(" ",@table_go);
    print "</div>";
print "</td>";
print "</tr>";
print "</table>";
print "<hr>";
print "<h2>Links between the MeSH D and the GO annotations </h2>";
# FRAME TO DISPLAY LINKS
print "<iframe name=\"link_frame\" id=\"link_frame\" width=\"60%\" height=\"200px\" seamless frameborder=\"0\"></iframe>";
print "</body>";
print "</html>";

}




