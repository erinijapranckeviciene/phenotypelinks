#!/usr/bin/perl -w
use strict;
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $query = new CGI;

my $prog  = $query->param('program');
my $data  = $query->param('data');
my $ident = $query->param('ident');

print $query->header;
#print "$prog<br>\n";
#print "$data<br>\n";
#print "$ident<br>\n";

system "perl $prog $data $ident";

print end_html;
