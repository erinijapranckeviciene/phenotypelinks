#!/usr/bin/perl
require "include3.pl";
use strict;
my $dat=shift;
my $id=shift;

my $ncbiurl="http://www.ncbi.nlm.nih.gov/gene?term=";

# This function reads gene tables  from $dat
# formats it as a table and prints it into stdout

# First step- open the data and read the line 
open(DAT,"<$dat") or "<p>err $! </p>\n";
my $tableline;
while(<DAT>)
{ chop;
  my($lid,$info)=split("\t",$_);

   if ($lid eq $id) 
     {$tableline=$info; }
 }
close(DAT);
#my @lines=split(" ",$tableline);
#shift @lines;
#print join(" ",@lines);

print $tableline;
exit;

