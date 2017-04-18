#!/usr/bin/perl
# Here we  generate the output
use strict;
use List::Util qw( min max );

###########################################################################
#########   URLS 
###########################################################################
my $geneurl="http://www.ncbi.nlm.nih.gov/gene?term=";
my $pmurl="http://www.ncbi.nlm.nih.gov/pubmed?term=";
my $ncbiurl="http://www.ncbi.nlm.nih.gov/gene?term=";
my $homourl="http://www.ncbi.nlm.nih.gov/homologene?term=";
my $gourl="http://amigo.geneontology.org/cgi-bin/amigo/term_details?term=";
my $meshurl1="http://www.nlm.nih.gov/cgi/mesh/2012/MB_cgi?mode=\&term=";
my $meshurl2="\&field=entry";
my $goonturl="http://amigo.geneontology.org/cgi-bin/amigo/term_details?term=";
my $phpurl="http://phenotypelinks.net/cgi-bin/";

my $HEIGHT="356px";

#(term with spaces[MeSH Terms]) AND term with spaces[MeSH Terms]


#######################################################                         
sub uniq { return keys %{{ map { $_ => 1 } @_ }}; }
######################################################
# make this piece into a subroutine
# instead of file we will take a stack of o5 table as input
# output will be sorted genes and evidence


########################################################
sub not_in_database{
########################################################
### ERRORS in MESH
    my ($ref)=@_;
    my @matchlist=@$ref;
    my $num=scalar @matchlist;
    my $showing;
    if ( $num>10){$showing=10;} else{ $showing=$num;}
    my $line1="Error in your query! Stopped.";
    my $line2="There are $num possible matches in database.";
    my $line3="Showing $showing matches:"; 
    my $line4="Please refine your query.";
    my $note=join("<br>",$line1,$line2,$line3,@matchlist[0..$showing],$line4);
    return($note);
}

#########################  HTML printing  part for table output
# we could print parameters in the header, think about
# 
sub print_html_header_small($tit)
{ 
    my $tit=$_[0];
     my @head;

   push @head, "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">";
   push @head,"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">";
   push @head,"<head>";
   push @head, "<title>$tit</title>";
   push @head,"<meta name=\"description\" content=\"website for gene prioritization\" />";
   push @head, "<meta name=\"keywords\" content=\"phenotype,gene,prioritization\" />";
    push @head,"<meta http-equiv=\"content-type\" content=\"text/html; charset=iso-8859-1\" />";
   push @head,"<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/ep_links.css\" />";
   push @head,"<script src=\"/projects/ep_links/sorttable.js\"></script>"; 
   push @head,"</head>";
   push @head,"<body>";
   
push @head,"<div style=\"width:100%; margin-top:10px;margin-left:25px\">";
#        <!-- insert the page content here -->
# push @head,"<div style=\"width:100%;\">";

   return(@head);
}

sub print_html_header_small_nomargin_table($tit)
###################################################################             
{
    my $tit=$_[0];
    my @head;

   push @head, "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://ww\
w.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">";
    push @head,"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">";
    push @head,"<head>";
    push @head, "<title>$tit</title>";
   push @head,"<meta name=\"description\" content=\"website for gene prioritization\" />";
   push @head, "<meta name=\"keywords\" content=\"phenotype,gene,prioritization\" />";
    push @head,"<meta http-equiv=\"content-type\" content=\"text/html; charset=iso-8859-1\" />";
   push @head,"<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/ep_links.css\" />";
      push @head,"</head>";
    push @head,"<body>";
    return(@head);
}

###################################################################
sub print_html_header_small_nomargin($tit)
###################################################################
{ 
    my $tit=$_[0];
     my @head;

   push @head, "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">";
   push @head,"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">";
   push @head,"<head>";
   push @head, "<title>$tit</title>";
   push @head,"<meta name=\"description\" content=\"website for gene prioritization\" />";
   push @head, "<meta name=\"keywords\" content=\"phenotype,gene,prioritization\" />";
   push @head,"<meta http-equiv=\"content-type\" content=\"text/html; charset=iso-8859-1\" />";
   push @head,"<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/ep_links.css\" />"; 
#   push @head,"<script src=\"/projects/ep_links/sorttable.js\"></script>"; 
   push @head,"</head>";
   push @head,"<body>";
   
#push @head,"<div style=\"width:100%; margin-top:10px;margin-left:25px\">";
#        <!-- insert the page content here -->
push @head,"<div style=\"width:100%;\">";

   return(@head);
}
########################################################################
sub print_html_header_gene_table
########################################################################
{ 
    my @head;

   push @head,"<html>";
   push @head,"<head>";
   push @head,"<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/ep_links.css\" />";
   push @head,"<script src=\"/projects/ep_links/sorttable.js\"></script>"; 
   push @head,"</head>";
   push @head,"<body>";
   return(@head);
}


###########################################################
sub print_html_footer_gene_table{
###########################################################
    my @foot;
push @foot,"</body>";
push @foot,"</html>";
return(@foot);

}

###########################################################
sub print_html_footer_small{
###########################################################
    my @foot;
push @foot,"</div>"; ################################# 100%
push @foot,"</body>";
push @foot,"</html>";

    return(@foot);
}

#####################################################################                 
sub create_html_evd_table{
####################################################################                  
    my ($ref1,$ref4)=@_;
    my @gt=@$ref1;
    my $mterm=$ref4;

    my @rezgt;

### CREATE TABLE WITH FIXED HEADER and LINKS to NCBI

    my $header="<tr><th style=\"width:20%;\">Score</th><th style=\"width:70%;\">MeshD</th><th style=\"width:10%;\">Pubmed</th></tr>";

    my @tabstart=&table_start($header);
    my @tabend=&table_end;

foreach my $l(@gt)
{  
    my($score,$term)=split("=",$l);

    # TO MESH
    my $tomesh=$term;
    $tomesh=~s/_/+/g;

    # TO PUBMED
    my $pm_mterm=$mterm;
    $pm_mterm=~s/_/ /g;    
    
    my $pm_dterm=$term;
    $pm_dterm=~s/_/ /g;


    # create references
    my $tomeshref=$meshurl1.$tomesh.$meshurl2;
    my $tomeshpart="<a href=\"$tomeshref\" target=_blank>$pm_dterm</a>";

    my $topubmedref=$pmurl."(".$pm_mterm."\[MeSH Term\]) AND ".$pm_dterm."\[MeSH Term\]";
    my $topubmedpart="<a href=\"$topubmedref\" target=_blank> >> </a>";

   my $line="<tr><td style=\"width:20%;\">$score</td><td style=\"width:70%;\">$tomeshpart</td><td style=\"width:10%;\">$topubmedpart</td></tr>";

  
push @rezgt,$line; 
}
                                                                                                   
### CREATE THE BEGINNING AND END                                                                    
my $tname="DTerms";                                                                                                    
my @start=&print_html_header_small_nomargin;
my @stop=&print_html_footer_small;
my @retrez=(@start,@tabstart,@rezgt,@tabend,@stop);
return(@retrez);                                                                                    
}


################################################## OUTER TABLE
sub table_start{
##############################################################
    my ($header,$height)=@_;

    my $tabheight;
    if ($height){ $tabheight=$height."px"; }
    else {$tabheight="300px";}

my @tabhead;
# push @tabhead,"<link href=\"http://phenotypelinks.net/browse/style/caroline/style_tablesort.css\" rel=\"stylesheet\">";

push @tabhead,"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
push @tabhead,"<tbody>";
push @tabhead,"<tr>";
push @tabhead,"<td>";
push @tabhead,"<table border=\"1\" cellpadding=\"0\" cellspacing=\"2\" width=\"100%\">";
push @tabhead,"<tbody>";
push @tabhead,$header;
push @tabhead,"</tbody>";
push @tabhead,"</table>";
push @tabhead,"</td>";
push @tabhead,"</tr>";
push @tabhead,"<tr>";
push @tabhead,"<td>";

push @tabhead,"<div style=\"overflow: auto; width: 100%; height:$tabheight;\">";
push @tabhead,"<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
push @tabhead,"<tbody>";

    return(@tabhead);
}

#####################################################################
sub table_end{
####################################################################
my @tabend;
## Table End
push @tabend,"</tbody>";
push @tabend,"</table>";
push @tabend,"</div>";
push @tabend,"</td>";
push @tabend,"</tr>";
push @tabend,"</tbody>";
push @tabend,"</table>";

return(@tabend);
}


#####################################################################
sub create_html_gene_table_new{
####################################################################
    my ($ref1,$ref2,$ref3,$ref5)=@_;
    my @gt=@$ref1;
    my @sources=@$ref2;
    my $dat=$ref3;
    my $bc=$ref5;
    my $table_title;
    my $HEIGHT;
   
    if( $bc==1){$table_title="Top Ranking Genome Genes";}
    if( $bc==2){$table_title="Candidate Genes";}

    my $tn=scalar @gt;
    if ( $tn > 18){ $HEIGHT=280;}
    else { $HEIGHT=10*$tn;}

    my $phpurl="http://phenotypelinks.net/cgi-bin";
    my @rezt;

    my %sn=( "lt"=>"Literature,","ho"=>"Homology+,","kg"=>"ContextGenes,");     
    my @snames=@sn{@sources};

    my @newnames;
    push @newnames,"<th class=\" sort-header\" style=\"text-align:center;\">CombinedScore</th>"; 
    push @newnames,"<th style=\"text-align:left;\"></th>";

    foreach my $nam(@snames)
    { my($p1,$p2)=split(",",$nam); 
      push @newnames,"<th class=\" sort-header\" style=\"text-align:center;\">$p1</th>"; 
      push @newnames,"<th style=\"text-align:left;\">$p2</th>";
     }

##################### START OF THE TABLE PAGE

    push @rezt,"<!DOCTYPE html>";
    push @rezt,"<html><head>";
    push @rezt,"<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">";
    push @rezt,"<link href=\"http://phenotypelinks.net/browse/style/caroline/style_tablesort.css\" rel=\"stylesheet\">";
    push @rezt,"</head>";
    push @rezt,"<body >";

#     push @rezt, "<table>";
#    push @rezt, "<thead>";
#    push @rezt,"<tr >";
#    push @rezt,"<th class=\"no-sort\"><h3 style=\"text-align:center;\">$table_title</h3></th>";
    push @rezt,"<h3 style=\"text-align:center;\">$table_title</h3>";
#    push @rezt,"</tr>";
#    push @rezt,"</thead>";
#    push @rezt,"</table>";

##################### REAL TABLE NOW HEADER
    my $l1="<table id=\"sort\" class=\"sort\"  height=\"$HEIGHT\" overflow=\"auto\">";
    push @rezt,$l1;
    push @rezt, "<thead>";
    push @rezt, "<tr>";


# header
   my $h1="<th class=\"sort-header\">Symbol</th><th class=\"sort-header\">Description</th>"; 
   my $h2=join("",@newnames);
  push @rezt,$h1;
  push @rezt,$h2;

    push @rezt,"</tr>";
    push @rezt,"</thead>";

##################### REAL TABLE NOW TBODY
    
   push @rezt,"<tbody>";

   my $count=0;

foreach my $l(@gt)
{   my($gid,$sym,$descr,@rest)=split(",",$l);

    my $dref="<a href='$ncbiurl$gid' target=_blank> $descr</a>";
    
     $count=$count+1;
     
    my $srefsym;
     if ($bc==2)
     { $srefsym=$sym." ($count)";}    
     if ($bc==1)
     {$srefsym=$sym;}
   
 my $sref_color="<a href='$phpurl/callproc.cgi?program=gene_annot2.pl&data=$dat&ident=$gid' target=\"annot_frame\" style=\"color:brown;\">$srefsym</a>";

 my $sref="<a href='$phpurl/callproc.cgi?program=gene_annot2.pl&data=$dat&ident=$gid' target=\"annot_frame\">$srefsym</a>";


    my @newrest;
    my $genetype=pop @rest;

    foreach my $r(@rest)
    { my($p1,$p2)=split(" ",$r); 
      push @newrest,"<td style=\"text-align:right;\">$p1</td>"; 
      push @newrest,"<td style=\"text-align:left;\">$p2</td>";}

   my $srefnew;
   if($genetype==1)
{ 

   $srefnew="<td> $sref_color </td>";


}

   else{$srefnew="<td>$sref</td>"; }
    my $d1="$srefnew<td>$dref</td>"; 
    my $d2=join("",@newrest); 
    my $d="<tr>".$d1.$d2."</tr>";
    push @rezt,$d;
}

push @rezt,"</tbody>";
my $l2="</table>";
push @rezt,$l2;
push @rezt,"<script src=\"http://phenotypelinks.net/browse/style/caroline/tablesort.js\"></script>";
push @rezt,"<script>";
push @rezt, " new Tablesort(document.getElementById('sort'));";
push @rezt, "</script>";
push @rezt,"</body></html>";
### CREATE THE BEGINNING AND END

return(@rezt); 

} #end sub


#####################################################################
sub create_html_gene_table{
####################################################################
    my ($ref1,$ref2,$ref3,$ref5)=@_;
    my @gt=@$ref1;
    my @sources=@$ref2;
    my $dat=$ref3;
    my $bc=$ref5;
    my $bgcol;
    my $HEIGHT;
   
    if( $bc==1){$bgcol="darksalmon";}
    if( $bc==2){$bgcol="darkseagreen";}

    my $tn=scalar @gt;
    if ( $tn > 18){ $HEIGHT=280;}
    else { $HEIGHT=10*$tn;}

    my $phpurl="http://phenotypelinks.net/cgi-bin";
    my @rezgt;

    my %sn=( "lt"=>"Literature,","ho"=>"Homology+,","kg"=>"KnownGenes,");     
    my @snames=@sn{@sources};

    my @newnames;
    push @newnames,"<th style=\"text-align:center;\">CombinedScore</th>"; 
    push @newnames,"<th style=\"text-align:left;\"></th>";

    foreach my $nam(@snames)
    { my($p1,$p2)=split(",",$nam); 
      push @newnames,"<th style=\"text-align:center;\">$p1</th>"; 
      push @newnames,"<th style=\"text-align:left;\">$p2</th>";
     }

    my $l1="<table class=\"sortable\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"$HEIGHT\" overflow=\"auto\" style=\"background-color:#E9E4C7;\">";

    push @rezgt,$l1;

# header
   my $h1="<th>Symbol</th><th>Description</th>"; 
   my $h2=join("",@newnames);
   my $h="<tr>".$h1.$h2."</tr>";
   push @rezgt,$h;

   my $count=0;
foreach my $l(@gt)
{   my($gid,$sym,$descr,@rest)=split(",",$l);

    my $dref="<a href='$ncbiurl$gid' target=_blank> $descr</a>";
    
     $count=$count+1;
     
    my $srefsym;
     if ($bc==2)
     { $srefsym=$sym." ($count)";}    
     if ($bc==1)
     {$srefsym=$sym;}
   
 my $sref_color="<a href='$phpurl/callproc.cgi?program=gene_annot2.pl&data=$dat&ident=$gid' target=\"annot_frame\" style=\"color:brown;\">$srefsym</a>";

 my $sref="<a href='$phpurl/callproc.cgi?program=gene_annot2.pl&data=$dat&ident=$gid' target=\"annot_frame\">$srefsym</a>";


    my @newrest;
    my $genetype=pop @rest;

    foreach my $r(@rest)
    { my($p1,$p2)=split(" ",$r); 
      push @newrest,"<td style=\"text-align:right;background-color:$bgcol;\">$p1</td>"; 
      push @newrest,"<td style=\"text-align:left;\">$p2</td>";}

   my $srefnew;
   if($genetype==1)
{ 

   $srefnew="<td style=\"background-color:$bgcol;\"> $sref_color </td>";


}

   else{$srefnew="<td style=\"background-color:$bgcol;\">$sref</td>"; }
    my $d1="$srefnew<td>$dref</td>"; 
    my $d2=join("",@newrest); 
    my $d="<tr>".$d1.$d2."</tr>";
    push @rezgt,$d;
}
    my $l2="</table>";
    push @rezgt,$l2;


### CREATE THE BEGINNING AND END

#my @start=&print_html_header_gene_table;
#my @stop=&print_html_footer_gene_table;
#my @retrez=(@start,@rezgt,@stop);

return(@rezgt); 

} #end sub



#############################################################
sub byscore1
#############################################################
{
# subroutine sorts the list based on vectors                                                          

    my @value1=split(",",$a); 
    my @value2=split(",",$b); 

    my $n1=scalar @value1;
    my $n2=scalar @value2;
    my $n=min($n1,$n2);
    my $i;
    for ($i=1; $i<=$n; $i++)
    {  if ($value1[$i]!=$value2[$i] ){last;}}
     return ( scalar $value2[$i] <=> scalar $value1[$i] );
}
#############################################################

sub time_note
{   my $ref=$_[0];
    my $note=$ref;
    my ($second, $minute, $hour, $dayOfMonth, $month, @rest) = localtime();
    my $time_data=join("  ",$note,join(':',$hour,$minute,$second),"<BR>");

    return($time_data);
}

####################################################################
sub go_table{
###################################################################
# HERE WE READ GOMAX TERMS FROM LITERATURE
# AND ALSO D ASSOCIATIONS 
    my ($ref1,$ref2)=@_;
    my $tableline=$ref1;
    my $dat=$ref2;
# line is there, process info
my @tableparts=split(";",$tableline);

    my $height=$HEIGHT;
    my $wc1="style=\"width:15%;\""; # To Dterm                                                              
    my $wc2="style=\"width:65%;\""; # GO term                                                                
    my $wc3="style=\"width:20%;text-align:center;\""; # GO score
############################### CREATE the TABLE FROM GOMAXSCORES
##  GOMAX TABLE Header

my $hl="<th>Links to MeSH D Connections</th><th>Weighted GO Terms </th><th> Maximum GO Weight</th>";
my $header="<tr  style=\"height:40px; vertical-align:top;cellpadding=5;border=1;\" >".$hl."</tr>";

    my @tabstart;
    push @tabstart,"<table style=\"text-align:center;\">";
    push @tabstart,$header;

    my @tabend;
    push @tabend,"</table>";


#my @tabstart=&table_start($header,$height);
#my @tabend=&table_end;
my @tablelines;

foreach my $line(@tableparts)
{ 

  my ($mscore,$g1,$goname,$gokey,$dgokey)=split("=",$line);
  my $ms=sprintf("%.3f",$mscore);

  $goname=~s/_/ /g;
  
  my $phpref="callproc.cgi?program=d_links2.pl&data=$dat&ident=$g1";
  my $to_d_link="<a href=$phpurl$phpref target=\"link_frame\"> v </a>";
  my $to_go_link="<a href=$goonturl$g1 target=_blank>$goname</a>";
  my $tline1="<td \"$wc1\">$to_d_link</td><td \"$wc2\">$to_go_link</td><td \"$wc3\">$ms</td>";

  my $tline2="<tr>".$tline1."</tr>";  
  push @tablelines,$tline2;
}

############################### table is @tabstart @tablelines @tabend
my @table=(@tabstart,@tablelines,@tabend);

return(@table);

} # end sub

####################################################################
sub d_table{
###################################################################
    my ($ref1,$ref2,$ref3)=@_;
    my $tableline=$ref1;
    my $mterm=$ref2;
    my $dat=$ref3;

# line is there, process info
my @tableparts=split(";",$tableline);
    my $wc1="style=\"width:10%;\""; # To Pubmed
    my $wc2="style=\"width:15%;text-align:center;\""; # Score
    my $wc3="style=\"width:60%;\""; # Dterm  
    my $wc4="style=\"width:15%;\""; # To Dterm
############################### CREATE the TABLE FROM GOMAXSCORES
##  GOMAX TABLE Header
#my $hl=join("</th><th>","To GO","MeSH D Term","MeshD-Phen Score","To Pubmed");
#my $header="<tr><th \"$wc1\">Pubmed</th><th \"$wc2\">MeSH D Score</th><th \"$wc3\">MeSH D Term</th><th \"$wc4\"> Linked GO</th></tr>";
    my $height=$HEIGHT;

#my @tabstart=&table_start($header,$height);
#my @tabend=&table_end;
my @tablelines;

my $header="<tr style=\"height:40px; vertical-align:top;cellpadding=5;\" ><th>Pubmed</th><th>MeSH D Score</th><th>MeSH D Term</th><th> Linked GO</th></tr>";

    my @tabstart;
    push @tabstart,"<table style=\"text-align:center;\">";
    push @tabstart,$header;

    my @tabend;
    push @tabend,"</table>";


foreach my $line(@tableparts)
{ 
  
  my ($mscore,$dterm,$mdkey)=split("=",$line);
  my $score=sprintf("%.3f",$mscore);


    # TO MESH
    my $tomesh=$dterm;
    $tomesh=~s/_/+/g;

    # TO PUBMED
    my $pm_mterm=$mterm;
    $pm_mterm=~s/_/ /g;    

    
    my $pm_dterm=$dterm;
    $pm_dterm=~s/_/ /g;


    # create references
    my $tomeshref=$meshurl1.$tomesh.$meshurl2;
    my $tomeshpart="<a href=\"$tomeshref\" target=_blank>$pm_dterm</a>";

    my $topubmedref=$pmurl."(".$pm_mterm."\[MeSH Term\]) AND ".$pm_dterm."\[MeSH Term\]";
    my $to_pubmed_link="<a href=\"$topubmedref\" target=_blank> << </a>";

  $dterm=~s/_/ /g;
  
  my $phpref="callproc.cgi?program=go_links2.pl&data=$dat&ident=$mdkey";
  my $to_go_link="<a href=$phpurl$phpref target=\"link_frame\"> v </a>";
  
#  my $tline1=join("</td><td>",$to_go_link,$tomeshpart,$ms,$to_pubmed_link);
my $line="<td \"$wc1\"> $to_pubmed_link </td> <td \"$wc2\">$score</td><td \"$wc3\">$tomeshpart</td><td \"$wc4\">$to_go_link</td>";
 

 my $tline2="<tr>".$line."</tr>";  

  push @tablelines,$tline2;
}

############################### table is @tabstart @tablelines @tabend
my @table=(@tabstart,@tablelines,@tabend);

return(@table);

} # end sub
####################################################################

####################################################################
sub print_results{
####################################################################

    my ($ref1)=@_;
    my %re=%$ref1;

#sections
    my $page_title  =$re{"page_title"};
    my $title       =$re{"title"};
    my $query       =$re{"query"};
    my $description =$re{"description"};
    my $table       =$re{"table"};
    
## Make description here.
my @dlines;
foreach my $t( split(";",$re{"table_tabs"}))
{ 
   my($name,$link)=split(" ",$t);
   push @dlines, "&nbsp;&nbsp;<a href=$link target=\"table_frame\">$name</a>&nbsp";
}
my $dline=join(" or ",@dlines); 


$description="<p> Here you find the ene prioritization results. Click on the links $dline to swith between the gene tables. Click on the gene Symbol to see below the weighted annotations, which led to this prioritizationresult. In each column the gene relative scores (rank ratios) are displayed for the used data sources. The gene position in the whole ranked genome is shown in the brackets (#) next to the score. The CombinedScore is the best score of all used data sources. To sort by the individual column, click on the header.Find more in the <a href=\"http://phenotypelinks.net/browse/userManual.php#list_genes\" target=_blank> <font style=\"color:A2AB3B;\"> User Manual </font></a></p>";
## END description 



my @lines;

push @lines, "<head>";
push @lines, "<title>$page_title</title>";

push @lines, "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css\">";

push @lines, "</head>";
push @lines, "<html>";
push @lines, "<body>";
push @lines, "<div id=\"main\" style=\"margin-bottom:0;\">";
push @lines, "<a href=\"http://phenotypelinks.net/browse/index.php\" target=\"_self\"><h1>$title</h1></a><br>";
push @lines,"</div>";
push @lines,"<div id=\"page_results\">";
push @lines,"<h2>Your submitted query contains the following information:</h2>";
push @lines, "<p>$query<br></p>";

    push @lines,"<hr>";
    push @lines,"$description";

# push @lines,"<hr>";
# Gene Table  Tabs
# push @lines, "<table width=50%>";
# push @lines, "<tr>";


#push @lines, "</tr>";
#push @lines, "</table>";
# Gene Table itself inframe. 
# Gene Table is generated by the separate program gene_table.pl
# here is the frame that will be filled
push @lines, "<iframe src=\"$table\" name=\"table_frame\" id=\"table_frame\" width=\"90%\" height=\"320px\" seamless frameborder=\"0\"> </iframe>";
push @lines, "<hr>";
# Evidence tabs

#push @lines, "<table width=50%>";
#push @lines, "<tr>";
push @lines,"<p> Examine the evidence for association that led to this gene prioritization by using the following data sources  ";
foreach my $t( split(";",$re{"evidence_tabs"} ) )
{ 
   my($name,$link)=split(" ",$t);
   push @lines, "&nbsp;&nbsp;&nbsp;&nbsp;<a href=$link target=_blank>$name</a>";
}
push @lines,". Click on the links to open the new pages for the evidence. </p>";
#push @lines, "</tr>";
#push @lines, "</table>";

push @lines, "<hr>";
push @lines, "<h2>Weighted GO annotations </h2>";
# FRAME TO DISPLAY ANNOTATIONS
push @lines, "<iframe name=\"annot_frame\" id=\"annot_frame\" width=\"90%\" height=\"700px\" seamless frameborder=\"0\"></iframe>";
push @lines, "</body>";
push @lines, "</html>";

return(@lines);
}



return 1;
