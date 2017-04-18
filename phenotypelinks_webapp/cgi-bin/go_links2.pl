#!/usr/bin/perl

use strict;
use DBI;

my $dat=shift;
my $id=shift;

my @outputlines;
my @row;
my $ws="style=\"width:20%;text-align:center;\"";
my $wt="style=\"width:60%;text-align:center;\"";

# mdkey is $id
# connection to the database

my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');
my $sql1;

## Here query DB and construct lines
## query to retrieve dterm,dtid and dscore from mesh_terms_1;
## query to retrieve go terms linked to dtid, compute maxscore and sort

  # query for dterm,dtid and dscore
  my $query="select mterm,dterm,dscore,dtid  from mesh_terms_1  where mid=$id;";
  $sql1 = $connection->prepare($query); $sql1->execute();
  @row=$sql1->fetchrow_array();
  my ($mterm,$dtitle,$dscore,$dtid)=@row;
  $dtitle=~s/_/ /g;


  # query for goterms connected to dtid
  my $query="select a.gscore*$dscore as ms, a.gscore, c.description from dterm_go as a, go_id_description as c where a.dtid=$dtid and a.goterm=c.goterm order by ms desc;";
  $sql1 = $connection->prepare($query); $sql1->execute();
while ( @row=$sql1->fetchrow_array())
{
  my ($maxs,$gscore,$goname)=@row;

  ####################
  my $gs=sprintf("%.3f",$gscore);
  my $ms=sprintf("%.3f",$maxs);
  $goname=~s/_/ /g;
  my $k="<tr><td \"$ws\">$gs</td><td \"$wt\">$goname</td><td \"$ws\">$ms</td></tr>";
  push @outputlines,$k;
  ##########################################
}

my $n=scalar @outputlines;

$sql1="";
$connection->disconnect();
################################## Finished DB Queries
#### Printing the table

print "<html>";
print "<head>";
print "</head>";
print "<body>";
print "<p> MeSH D Term <font style=\"color:brown;font-size:larger;\" >$dtitle</font>.  Total linked GO terms $n.";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css\" />";
print "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
print "<tr  style=\"height:20px; vertical-align:top;cellpadding=5;\"><th \"$ws\">Connection Strength MeSHD to GO Term</th><th \"$wt\">GO Term Descripton</th><th \"$ws\">GO Term Maximum Score</th></tr>";
foreach my $o(@outputlines)
{
print "$o";
}
print "</table>";
print "</body>";
print "</html>";
