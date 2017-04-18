#!/usr/bin/perl

use strict;
use DBI;

my $inmterm=shift;
my $ingoterm=shift;


#################################

my $ws="style=\"width:20%;text-align:center;\"";
my $wt="style=\"width:60%;text-align:center;\"";

# dscore,dterm,gscore
# goterm is $ingoterm
# connection to the database

my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');
my $sql1;

  # complex query for dscore,dterm,gscore;
  my $query="select b.dscore, b.dterm, a.gscore from dterm_go as a, mesh_terms_1 as b where a.goterm=\'$ingoterm\' and a.dtid=b.dtid and b.mterm=\'$inmterm\' order by dscore desc;";

  $sql1 = $connection->prepare($query); $sql1->execute();

  my @outputlines;
  my @row;

while(  @row=$sql1->fetchrow_array())
{
   my ($dscore,$dterm,$gscore)=@row;
   my $gs=sprintf("%.3f",$gscore);
   my $ds=sprintf("%.3f",$dscore);
   $dterm=~s/_/ /g;
  my $k="<tr><td \"$ws\">$ds</td><td \"$wt\">$dterm</td><td \"$ws\">$gs</td></tr>";
  push @outputlines,$k;

}

# GOTERM NAME
my $query="select description,category  from go_id_description where goterm=\"$ingoterm\";";
$sql1 = $connection->prepare($query); $sql1->execute();
my $description;
my $category;

while(@row=$sql1->fetchrow_array())
{  ($description,$category)=@row;}
$description=~s/_/ /g;
my $gotitle="$ingoterm <font style=\"color:brown;font-size:larger;\">$description.</font> $category.";

$sql1="";
$connection->disconnect();

################################## Finished DB Queries
#### Printing the table
print "<html>";
print "<head>";

print "</head>";
print "<body>";
my $n=scalar @outputlines;
print  "<p>$gotitle Total linked MeSH D terms $n. </p>";
print  "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks/browse/style/caroline/style_header_for_pageResults.css\" />";

print "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
print "<tr  style=\"height:20px; vertical-align:top;cellpadding=5;\"><th \"$ws\"> Connection Strength $inmterm MeSH D</th><th \"$wt\">MeSH D Term</th><th \"$ws\">Connection Strength MeSH D GO Term</th></tr>";
foreach my $o(@outputlines)
{
print $o;
}
print "</table>";
print "</body>";
print "</html>";
