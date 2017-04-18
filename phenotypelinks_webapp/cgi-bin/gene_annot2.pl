#!/usr/bin/perl
require "include3.pl";
use strict;
use DBI;

my $dat=shift;
# gene id
my $id=shift;


my @lines;
my $alit;
my $akg;

#my $did="EV_DGO";

open(DAT,"<$dat") or "<p>err $! </p>\n";
my $aid="ANNOT";           

while(<DAT>)
{ chop;
  my($lid,$l1,$l2)=split("\t",$_);
  if ($aid eq $lid)
  {
     $alit=$l1;
     $akg=$l2;  
   }
}
close(DAT);

#All genes are separated by ;
# Annotations are separated by ,
# the first number is gene ID
#To pick the gene we will compare and will stop if found

my @out;

# connection to the database
my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');
my $sql1;
my @row;
my %taxh=(10090=>"mouse",9606=>"human",7227=>"fly");

 my $query="select symbol,description  from gene_info_filt where geneid=$id;";
 $sql1 = $connection->prepare($query); $sql1->execute();
 @row=$sql1->fetchrow_array();

 my ($symbol,$gdescription)=@row;
$gdescription=~s/_/ /g;
my $line="<h3 style=\"font-size:larger;\">Gene <font color=\"blue\"> $symbol </font> ID $id, <font color=\"blue\"> $gdescription </font></h3>";
push @out,$line;
$sql1="";
$connection->disconnect();

my @litgoannot;
my @kggoannot;

# Literature
if (length($alit)>1){
####  CALL THE FUNCTION
 @litgoannot=&lit_annot_table($alit,$id);
}

if (length($akg)>1){
@kggoannot=&kg_annot_table($akg,$id);
}

print "<html>";
print "<head>";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css\" />";
print "</head>";
print "<body>"; 
# HERE WHICH GENE

print "<div width=\"100%\" style=\"margin:0px\">";
print join(" ",@out);



#HERE TABLE IN THE TABLE
print "<table width=\"100%\" cellspacing=\"0px\" cellpadding=\"0px\" border=\"0px\">";
print "<tr>";
print "<td>";

my $tot=scalar @litgoannot -23;
print "<p> Annotations weighted by literature <font color=\"brown\">total $tot </font></p>";
print "</td>";
print "<td>";

my $tot=scalar @kggoannot-23;
print "<p> Annotations scored by Resnik similarity <font color=\"brown\">total $tot </font></p>";
print "</td>";
print "<tr>";

print "<tr>";
print "<td>";
print join(" ",@litgoannot);
print "<p></p>";
print "</td>";

print "<td>";
print join(" ",@kggoannot);
print "<p></p>";
print "</td>";
print "</tr>";
print "</table>";

print "</body>";
print "</html>";
exit; 


####################################################################
sub lit_annot_table{
###################################################################
   my ($ref1,$ref2)=@_;
    
   my $alit=$ref1;
   my $id=$ref2;

print "in function \n";
   print $id,"\n";
  




############################### CREATE the TABLE FROM GOMAXSCORES
##  GOMAX TABLE Header

my $height=300;
#### Here the width of the table cells
### IN LITGOANNOT
my $wcl1="style=\"width:10%;text-align:center;\"";
my $wcl2="style=\"width:35%;text-align:center;\"";
my $wcl3="style=\"width:10%;text-align:center;\"";
my $wcl4="style=\"width:10%;text-align:center;\"";
my $wcl5="style=\"width:35%;text-align:center;\"";


my $cwcl1="style=\"width:10%;text-align:center;color:brown;\"";
my $cwcl2="style=\"width:35%;text-align:center;color:brown;\"";
my $cwcl3="style=\"width:10%;text-align:center;color:brown;\"";
my $cwcl4="style=\"width:10%;text-align:center;color:brown;\"";
my $cwcl5="style=\"width:35%;text-align:center;color:brown;\"";


my $header= "<tr style=\"height:35px;\"><th $wcl1> Max GO Score</th><th $wcl2>GO Term</th><th $wcl3>Organism</th><th $wcl4>GO-MeSHD Connection</th><th $wcl5>MeSH Dterm</th></tr>";

my @tabstart=&table_start($header,$height);
my @tabend=&table_end;
   my @tablelines;

my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');
my @ga=split(";",$alit);

my @otherannot;

foreach my $part(@ga)
{ 
  my @annot=split(",",$part);
  my $first=shift @annot;
 #   print $first,"\n";
 #   my $ask=getc;
  
  my ($geneid,$ms,$go,$tax,$dgokey)=split("=",$first);
  unshift @annot,join("=",$ms,$go,$tax,$dgokey);
  @otherannot=@annot;
  if ($geneid==$id){last;}
}

 # PRINT the gene annotations
# We also have to find the links to mesh D through the EV DGO


print scalar @otherannot,"\n";

my @row;
my $count=1;
foreach my $p(@otherannot)
{ 

 my($ms,$go,$tax,$dgokey)=split("=",$p);
 my $ms1=sprintf("%.3f",$ms);
 # query for dgokey;
 my $query="select gscore,dterm from dterm_go where id=$dgokey;";
 $sql1 = $connection->prepare($query); $sql1->execute();
 @row=$sql1->fetchrow_array();
 my ($gs,$dterm)=@row; 
 my $gscore=sprintf("%.3f",$gs);
 # query for go description;                                                                                                 
 my $query="select description  from go_id_description where goterm=\"$go\";";
 $sql1 = $connection->prepare($query); $sql1->execute();
 @row=$sql1->fetchrow_array();
 my ($description)=@row;
 $description=~s/_/ /g;
 my $taxn=$taxh{$tax};
 $dterm=~s/_/ /g;

 my $k="<td $wcl1>$ms1</td><td $wcl2>$description</td><td $wcl3>$taxn</td><td $wcl4>$gscore</td><td $wcl4>$dterm</td>";
 my $line="<tr>".$k."</tr>";
 
if($count==1)
{ 
  $count=2;
  $k="<td $cwcl1>$ms1</td><td $cwcl2>$description</td><td $cwcl3>$taxn</td><td $cwcl4>$gscore</td><td $cwcl5>$dterm</td>";
  $line="<tr>".$k."</tr>";
}

push @tablelines,$line;

}

$sql1="";
$connection->disconnect();
############################### table is @tabstart @lithoannot @tabend

my @table=(@tabstart,@tablelines,@tabend);

print scalar @table,"\n";
return(@table);

} # end sub


####################################################################
sub kg_annot_table{
###################################################################
   my ($ref1,$ref2)=@_;
    
   my $akg=$ref1;
   my $id=$ref2;


############################### CREATE the TABLE FROM GOMAXSCORES
##  GOMAX TABLE Header

my $height=300;
# Table Cell widths


### IN KGANNOT
my $wck1="style=\"width:20%;text-align:center;\"";
my $wck2="style=\"width:60%;text-align:center;\"";
my $wck3="style=\"width:20%;text-align:center;\"";

my $cwck1="style=\"width:20%;text-align:center;color:brown;\"";
my $cwck2="style=\"width:60%;text-align:center;color:brown;\"";
my $cwck3="style=\"width:20%;text-align:center;color:brown;\"";



my $header= "<tr  style=\"height:35px;\"><th $wck1> Resnik Score</th><th $wck2>GO Term</th><th $wck3>Organism</th></tr>";


my @tabstart=&table_start($header,$height);
my @tabend=&table_end;
my @tablelines;


my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');
my @ga=split(";",$alit);


my @otherannot;

my @ga=split(";",$akg);
my @otherannot;

foreach my $part(@ga)
{ 
  my @annot=split(",",$part);
  my $first=shift @annot;
  
  my ($geneid,$ms,$go,$tax)=split("=",$first);
  unshift @annot,join("=",$ms,$go,$tax);
  @otherannot=@annot;
  if ($geneid==$id){last;}
}

my $count=1;
foreach my $p(@otherannot)
{ 

 my($ms,$go,$tax)=split("=",$p);
 my $ms1=sprintf("%.3f",$ms);
 
 # query for go description;                                                                                                 
 my $query="select description  from go_id_description where goterm=\"$go\";";
 $sql1 = $connection->prepare($query); $sql1->execute();
 @row=$sql1->fetchrow_array();
 my ($description)=@row;
 $description=~s/_/ /g;
 my $taxn=$taxh{$tax};

 my $k1="<td $wck1>$ms1</td><td $wck2>$description</td><td $wck3>$taxn</td>";
 my $line="<tr>".$k1."</tr>";

if($count==1)
{ $count=2;
  my $k1="<td $cwck1>$ms1</td><td $cwck2>$description</td><td $cwck3>$taxn</td>";
 $line="<tr>".$k1."</tr>";
}

 push @tablelines,$line;
}

$sql1="";
$connection->disconnect();
############################### table is @tabstart @kggoannot @tabend
my @table=(@tabstart,@tablelines,@tabend);

return(@table);

} # end sub
####################################################################
