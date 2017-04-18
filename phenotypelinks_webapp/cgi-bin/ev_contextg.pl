#!/usr/bin/perl
use strict;
require  "include3.pl";


my $dat=shift;
my $id=shift;

my $gourl="http://amigo.geneontology.org/cgi-bin/amigo/term_details?term=";
my $ncbiurl="http://www.ncbi.nlm.nih.gov/gene?term=";


# HERE WE READ GOMAX TERMS FROM LITERATURE
# AND ALSO D ASSOCIATIONS 

# First step- open the data and read the line 
open(DAT,"<$dat") or "<p>err $! </p>\n";
# Line header is 
#my $id="KG_MAXGO";
# Maybe later we consider including context gos and context genes
#my $dinf="EV_D";

my $tableline;
my $dline;
my $dtot;
my $known_genes;

while(<DAT>)
{ chop;
  my($lid,$tot,$info)=split("\t",$_);
 # print $lid,"\n";
  if ($lid eq "KG_MAXGO") 
     {$tableline=$info; $dtot=$tot;}
 if ($lid eq "KNOWN_GENES") 
     {$known_genes=$tot;}
}
close(DAT);
# line is there, process info
my @tableparts=split(";",$tableline);
### CREATE the TABLE FROM GOMAXSCORES

#######################  Create the table
my @tablelines;

push @tablelines,"<table width=\"85%\" style=\"text-align:center;\">";
#### Header
my $hl=join("</th><th width=\"75%\">","Score","GO Term");
my $header="<tr  style=\"height:40px; vertical-align:top;cellpadding=5;border=1;\" ><th width=\"15%\">".$hl."</th></tr>";

push @tablelines,$header;

foreach my $line(@tableparts)
{ 

  my ($mscore,$g1,$goname)=split("=",$line);
  my $ms=sprintf("%.3f",$mscore);

$goname=~s/_/ /g;
  
  my $go_link="<a href=$gourl$g1 target=_blank> $goname </a>";
  

  my $tline1=join("</td><td width=\"75%\">",$ms,$go_link);
  my $tline2="<tr><td width=\"15%\">".$tline1."</td></tr>";  
  push @tablelines,$tline2;
  #print $tline2,"\n";
  #my $ask=getc;
}
push @tablelines,"</table>";


my %results_section=( 
"page_title"  =>"Page title",
"title"       =>"Title",
"query"       =>"Phenotype,organism,homology,context genes",
"context_genes" =>"List of context genes with links to NCBI? Do we need a frame to display a gene info?",
"description_go" =>"Description of the GO evidence",
"table_go"      =>"callproc.cgi?program=kg_table.pl&data=sessions/test.dat&ident=KG_GOMAX"

);

$results_section{"table_go"}=\@tablelines;
$results_section{"context_genes"}=$known_genes;
$results_section{"page_title"}="Evidence from Context Genes";
$results_section{"title"}="Evidence for <span class=\"alternate_colour\">Phenotype</span> defined by context genes";

my $n=scalar @tablelines;
$results_section{"description_go"}="Here the Gene Ontology annotations connecting the annotations of the <b>context genes </b> with the rest of the Gene Ontology are listed. The the most informative annotations  out of total <font style=\"color:brown;\">$dtot </font> and their  Resnik similarity scores are in the table. Click on the GO term for examinining it in the Gene Ontology database. Find more in the <a href=\"http://phenotypelinks.net/browse/userManual.php#evidence_contextg\" target=_blank> <font style=\"color:#A2AB3B;\"> User Manual </font></a>";



&print_ev_contextg(\%results_section);


sub print_ev_contextg{

    my ($ref1)=@_;
    my %re=%$ref1;

#sections
    my $page_title  =$re{"page_title"};
    my $title       =$re{"title"};
    my $query       =$re{"query"};
    my $context_genes =$re{"context_genes"};
    my $description_go =$re{"description_go"};
    
    my $table_go      =$re{"table_go"};
    my @table=@$table_go; 


    $context_genes=~s/,/ /g;
print "<head>";
print "<title>$page_title</title>";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css\">";
print "</head>";

print "<html>";
print "<body>";
print "<div id=\"main\" style=\"margin-bottom:0;\">";
print "<h1>$title</h1>";
    print "</div>";
print "<div id=\"page_results\">";
print "<h2> Your Context Genes:</h2>";
print "<h2>$context_genes</h2>";
print "<hr>";     
# Evidence Table  Tabs

print "<p>$description_go</p>";
print "<hr>";

# here is the table that will be filled

print "<table width=\"70%\" cellspacing=\"0\" cellpadding=\"0\" >";
# Table row for the actual tables
print "<tr>";
print "<td>";
print "<div style=\"width=100%;height:450px;vertical-align:top;overflow:auto;margin:0\" >";
print join(" ",@table);
print "</div>";
print "</td>";
print "</tr>";
print "</table>";
print "</body>";
print "</html>";

}




