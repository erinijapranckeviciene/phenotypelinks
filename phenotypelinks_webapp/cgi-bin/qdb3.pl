#!/usr/bin/perl
require "include3.pl";
$|=1;
#
use strict;
use List::Util qw( min max );

my $sessiondir="/var/www/html/browse/sessions/";
my $phpurl="http://phenotypelinks.net/cgi-bin";


####### Reading from the session comes first
my $sessionname=shift;

my $message=$sessiondir.$sessionname."PR.html";
system("echo \"message\" >> $message");

my $session=$sessiondir.$sessionname.".ses";
my $html=$sessiondir.$sessionname.".html";
my $dat=$sessiondir.$sessionname.".dat";
my $gene_table_html=$sessiondir.$sessionname."GL.html";
my $evd_html=$sessiondir.$sessionname."EVD.html";

my $gene_table_url="http://phenotypelinks.net/browse/sessions/".$sessionname."GL.html";

my $linkcolor="indigo";
my %results_section;

my $tab_candidates="Candidate_genes $phpurl/callproc.cgi?program=gene_table.pl&data=$dat&ident=SORTED_LIST_COMBINED";

my $tab_top="Top_Ranked_Genome $phpurl/callproc.cgi?program=gene_table.pl&data=$dat&ident=SORTED_TOP1_COMBINED";

my $tab_evlit="Literature $phpurl/callproc.cgi?program=ev_literature.pl&data=$dat&ident=EV_GOMAX";

my $tab_evkg="Context_genes $phpurl/callproc.cgi?program=ev_contextg.pl&data=$dat&ident=EV_CONTEXTG";

my $prog_candidates="$phpurl/callproc.cgi?program=gene_table.pl&data=$dat&ident=SORTED_LIST_COMBINED";

my $prog_top="$phpurl/callproc.cgi?program=gene_table.pl&data=$dat&ident=SORTED_TOP1_COMBINED";

$results_section{"title"}="<span class=\"alternate_colour\">Phenotype Links </span> tool";
$results_section{"description"}="Prioritization results";


my %pars;


open(HTML,">$html") or print "\n\n can not open $html and $!\n";
open(OUT,">$dat") or print " $dat err $!\n";

##################### Read parameters #########################
open(SES,"<$session") or print "\n\n\n\n can not open $session \n\n\n\n"; # go no further from here if sess cant open

while(<SES>)
{  chop;
   my($key,$val)=split("=",$_);
   $pars{$key}=$val;
#   print " inqdb key    $key <br> value $val <br> \n";
}
close(SES);

#print "Have read parameters <br> \n";

#############################################################
my $progress_path=$pars{"progress_path"};

system("echo \"$progress_path\"  >> $progress_path");


################ Organism mappings
my %taxa=("mouse"=>10090,"human"=>9606, "fly"=>7227);

########################################  WRITE QUERY SECTION  TO THE DAT FILE
my $line="QUERY_FULL"."\t";
my @parts;
foreach my $p(keys %pars)
{ my $l1=join("=",$p,$pars{$p}); push @parts,$l1;}
print OUT $line,join(";",@parts),"\n";
################################################################################

# Phenotype term and organism table name come as parameters
# Query parameters should synchronize with previous program

my $mterm  = $pars{"mesh"};
my $organism = $taxa{ $pars{"organism"}};
my $dscore = $pars{"dfrac"};
my $goscore= $pars{"gofrac"};
my $score_genes=$pars{"score_genes"};
my $file_score_genes=$pars{"file_score_genes"};
my $known_genes =$pars{"known_genes"};
my $file_known_genes=$pars{"file_known_genes"};
my $homology = $pars{"homology"};
my $dfrac=$pars{"dfrac"};
my $gofrac=$pars{"gofrac"};

##############################################################################
### Title of the page
$results_section{"page_title"}=$mterm." Gene List";

### Your Query
{
    my $h="No";
    my $k="";

    if ($homology){$h="Yes";}
    my @kng=split(",",$known_genes);
    my $total=scalar @kng;
    my $num=min ($total,10);
    if ($total>0){$k=join(",",@kng[0..$num]);}
    if ($total>$num){ $k.="...";}

    my $mt="Mesh Term : <b>".$mterm."</b>";
    my $ot="Organism chosen : <b>".$pars{"organism"}."</b>";
    my $ht="Homology included : <b>".$h."</b>";

    if($total>0){
    my $ct="Queried context genes ( $total ) : ".$k."</b>";
    $results_section{"query"}=join("<br>",$mt,$ot,$ht,$ct);
    }
    else{   $results_section{"query"}=join("<br>",$mt,$ot,$ht); } 

}


###############################################################################
my $line="QUERY_PAGE"."\t";
print OUT $line,$results_section{"query"},"\n";
################################################################################

### Parameters dfrac gofrac matter in fast
### Step1- based on the input call the procedures and collect the tables from the database
### Step2- sort the genes
### Step3 - sort genes combined
### Spep3 - generate scored genes and Top1 Tables. 
### Step5 - maybe we need to collect reduced evidence now. 
### Going from the genes - get the annotations  

print "Connecting to the database, will check errors in input <br>\n";
use DBI;
sub uniq { return keys %{{ map { $_ => 1 } @_ }}; } 

my $connection = DBI->connect('dbi:mysql:ep_links','xxx','xxx');    
my $sql1;
my @entrezid;

#####################        THIS IS STEP1                  ########################
##################### Based on what parameters are provided #########################
##################### we will call stored procedures        #########################
# 
#            lit_gomax1( queryterm,dfrac,gofrac) 
#
# Creates temporary tables d_terms and go_maxscores
# Here we also need to take the papers with d_terms and genes with gomaxscores
# Lit go max creates evidence tables , that we need to take
#
#           ev_gomax,
#               a.maxscore, b.goterm, b.description, 
# 
#            ev_d 
#             b.dterm as dt ,b.dscore,b.inters,b.nd,b.pmids,
#
#            ev_dgo
#               goterm,ident
#
#            lit_gene_table_organism(organism)   lit_gene_table_homology(organism)
#
# Creates temporary table gene_scores_organism, gene_scores_homology
# Here we also need to get gene information and store annotations 
# 
#             kg_tables1(in gslist text, in gslist_n int, in organism int)
#
# Creates temporary tables kg_maxgo  and  kg_gene_scores
#
#######################################################################################
#print "start queries\n";

my %lit_org_genes;
my %lit_hom_genes;
my %kg_genes;

#Evidence 
my %ev_gomax;
my $tot_ev_gomax;
my %ev_d;
my $tot_ev_d;
my %ev_dgo;
my %kg_maxgo;
my $tot_kg_maxgo;
my %context_gos;
my $tot_context_gos;
my %context_genes;
my $tot_context_genes;

#Annotations
my %gene_inf1;
my @all_genes;
my %annot_lit;
my %annot_kg;

my @row;
my %sr; 

# Totals
my %totals;

###################################################### LIT GENE TABLES ###############################

############## ERROR CHECKING
### IF mterm provided , then check if it is correct, if not give a warning
if( length($mterm)>0)
{ 
  my $query="select count(*) from mterms where mterm='$mterm';";
$sql1 = $connection->prepare($query); $sql1->execute();

@row=$sql1->fetchrow_array();
 if ($row[0]==0)
 {
     my $query="select mterm from mterms where mterm like '\%$mterm\%';";
     $sql1 = $connection->prepare($query); $sql1->execute();
    
     my @matches;
     while(@row=$sql1->fetchrow_array())
     {  push @matches,$row[0];}
     # subroutine to inform 
     my $note=&not_in_database(\@matches);
     print "$note <br> \n";
     #my $ask=getc;
     system("echo \"$note\" >>  $progress_path");
     exit; 
  } 
}
print "&nbsp&nbsp OK phenotype mesh term $mterm<br>\n"; 


### Check for consistency in gene names
### Loaded sql procedure check_gene_names1
if( length($known_genes)>0)
{ 
    my $gn=scalar split(",",$known_genes);

    my $query="call check_gene_names(\"$known_genes\",$gn);";
#    print "QUERY  ", $query,"\n";     

    $sql1 = $connection->prepare($query); $sql1->execute();
#    while( @row=$sql1->fetchrow_array){ print join(",",@row),"\n";}
#    print $sql1->rows,"\n";
    $sql1->finish();
#    my $ask=getc;
    if($sql1->rows==0)
    { 
	my $errcode="Errors in known gene list!. Stopped. <br> Refine your query. <br>";
     print "$errcode <br> \n";
     print "$known_genes <br> \n";
     #my $ask=getc;
	exit;
     system("echo \"$errcode\" >> $progress_path"); exit;
}
} 
print"&nbsp&nbsp OK consistency in known gene names<br>\n"; 

### 
if( length($score_genes)>0)
{ 
    my $gn=scalar split(",",$score_genes);
    my $query="call check_gene_names(\"$score_genes\",$gn);";
    $sql1 = $connection->prepare($query); $sql1->execute();
    my @row;
    @row=$sql1->fetchrow_array();
    if($sql1->rows==0)
    { 
	my $errcode="Errors in your gene candidates list!. Stopped. <br> Refine your query. <br>";
     print "$errcode <br> \n";
 #    my $ask=getc;
     system("echo \"$errcode\" >> $progress_path"); 
    exit;
}
} 
print"&nbsp&nbsp OK consistency in candidate gene names<br>\n"; 
############################## END OF ERROR CHECKING #############
print "Computing mesh-dterm-go links <br>\n";
## Create tables, based on the parameters
if ($mterm)
{   $sr{"lt"}="lt";
    my $query="call lit_gomax3('$mterm',$dfrac,$gofrac);";
#    print "QUERY :  $query<br>\n";  

    $sql1 = $connection->prepare($query); $sql1->execute();

    $query="call lit_gene_table_organism($organism);";
#    print "QUERY :  $query<br>\n";  

    $sql1 = $connection->prepare($query); $sql1->execute();

#    print "past lit_gene_table_organism \n";

system("echo \"<p>Literature gene table created</p>\" >> $progress_path");
system("date >> $progress_path");

my $query="select * from gene_scores_organism;";
#print "QUERY :  $query<br>\n";  

$sql1 = $connection->prepare($query); $sql1->execute();

while(@row=$sql1->fetchrow_array())
{   $lit_org_genes{$row[0]}=join(",",$row[0],$row[1]); push @all_genes,$row[0];}
#print "Total genes annotated by weighted go terms", scalar keys %lit_org_genes,"<br>\n";

my $note="Created temporary tables of phenotype-dterm-go links.";
my $time_data=&time_note($note);

print "$time_data\n";
system("echo \"$time_data\" >>  $progress_path");

###################################################### LIT HOMOLOGY  GENE TABLES ###############################
if($homology==1)
{     $sr{"ho"}="ho";
      $query="call lit_gene_table_homology($organism);";
     # print "QUERY :  $query\n";  
      
$sql1 = $connection->prepare($query); $sql1->execute();

my $query="select * from gene_scores_homology;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{   $lit_hom_genes{$row[0]}=join(",",$row[0],$row[1]);  push @all_genes,$row[0];}
#print "Total genes annotated by go terms (organism+homologs)", scalar keys %lit_hom_genes,"\n";
}


#    $sql1->finish();
#    $connection->disconnect();
#     print "stop\n";
#
#     exit(0);
 
###################################################### EVIDENCE FROM LIT ####################
############################ EV_GOMAX
my @parts;
my $query="select * from ev_gomax order by ms desc;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{     
      #my($ms,$goterm,$description)=@row;
      my $k=join("=",@row);
      push @parts,$k;
}

my $query="select count(*) from t4;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
@row=$sql1->fetchrow_array();
my ($true_ev_gomax)=@row;


$tot_ev_gomax=scalar @parts;
############## Write to the disk
############## EV GOMAX
my $line="EV_GOMAX"."\t".$true_ev_gomax."\t".$tot_ev_gomax."\t";
print OUT $line,join(";",@parts),"\n";

#print "EV_GOMAX created\n";

############################ EV_D
my @parts;
my $query="select * from ev_d order by dscore desc;";
#print "QUERY :  $query\n";  
     
$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{ 
        
      my($s,$dt,$dtid,$mdkey)=@row;
      my $sc=sprintf("%.4f",$s);
      my $k=join("=",$sc,$dt,$mdkey);
#      print join(" ",@row),"\n";
#      print $k,"\n";
#      my $ask=getc;    
      push @parts,$k;
}

my $query="select count(*) from t4 group by dtid;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
@row=$sql1->fetchrow_array();
my ($true_ev_d)=@row;

$tot_ev_d=scalar @parts;
$totals{"ev_d"}=$tot_ev_d;
############## WRITE TO THE DISK EV D
my $line="EV_D"."\t".$true_ev_d."\t".$tot_ev_d."\t";
print OUT $line,join(";",@parts),"\n";
#print "EV_D created \n";

#my $ask=getc;
#exit(0);

#########################################################

############################ DGOKEY  and MDKEY  
############################ EV_DGO
my @parts;
my $query="select * from ev_dgo;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{     my( $goterm,$ident)=@row;
      
       push @parts,join(" ",$goterm,$ident);
}
############## WRITE TO THE DISK EV DGO
my $line="EV_DGO"."\t";
print OUT $line,join(";",@parts),"\n";
#print "EV_DGO created \n";

#################### EV_MDKEY
my @parts;
my $query="select * from ev_mdkey;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{     my( $mdkey,$ident)=@row;
      
       push @parts,join(" ",$mdkey,$ident);
}
############## WRITE TO THE DISK EV MDKEY
my $line="EV_MDKEY"."\t";
print OUT $line,join(";",@parts),"\n";
#print "EV_MDKEY created \n";

############################################### GENE ANNOTATIONS FROM THIS PART
my $query="select * from gene_annot_list;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{     my( $gid,$annot)=@row;
     $annot_lit{$gid}=join("=",@row);
}

#print "total in gene_annot_list ",scalar keys %annot_lit,"\n";

############### OUTPUT SECTIONS FOR EVIDENCE
$tab_evlit="Literature $phpurl/callproc.cgi?program=ev_literature.pl&data=$dat&ident=$mterm";
$results_section{"evidence_tabs"}.=$tab_evlit.";";

my $note="Evidence for gene-phenotype links from literature prepared.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");
print "$time_data\n";

####### ####### DROP TABLES THAT NO LONGER NEEDED
my $query="drop table if exists t1,t2,t3,t4,t5,t6,t7;";
#print "QUERY :  $query\n";  
$sql1 = $connection->prepare($query); $sql1->execute();

my $query="drop table if exists ev_gomax,ev_d,ev_dgo,ev_mdkey;";
#print "QUERY :  $query\n";  
$sql1 = $connection->prepare($query); $sql1->execute();

}


###################################################### IF KNOWN GENES ###############################
if($known_genes)
{    $sr{"kg"}="kg";
    my $ng=scalar split(",",$known_genes);
    my $query="call kg_tables1(\"$known_genes\",$ng,$organism);";
#    print "QUERY :  $query\n";  

    $sql1 = $connection->prepare($query); $sql1->execute();

system("echo \"known genes table created\" >> $progress_path");
system("date >> $progress_path");

################################################### SELECT GENES 
my $query="select geneid,scores from kg_gene_scores;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();

while(@row=$sql1->fetchrow_array())
{   $kg_genes{$row[0]}=join(",",$row[0],$row[1]);  push @all_genes,$row[0];}
################################################### SELECT EVIDENCE

my $query="select * from kg_maxgo;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{   my($score,$goterm,$description)=@row;
    $kg_maxgo{$goterm}=join("=",@row); 
}
$tot_kg_maxgo=scalar keys %kg_maxgo;
$totals{"kg_maxgo"}=$tot_kg_maxgo;
############################################### GENE ANNOTATIONS FROM THIS PART
my $query="select * from gene_annot_list_kg;";
#print "QUERY :  $query\n";  

$sql1 = $connection->prepare($query); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{     my( $gid,$annot)=@row;
     $annot_kg{$gid}=join("=",@row);
}

############################################################### WRITE TO DISK NOW

my $tab_evkg="Context_genes $phpurl/callproc.cgi?program=ev_contextg.pl&data=$dat&ident=$known_genes";
$results_section{"evidence_tabs"}.=$tab_evkg;


################################################################ WRITE KG_MAXGO, CONTEXT GOS CONTEXT GENES
######### KG MAXGO
my $line="KG_MAXGO"."\t".$tot_kg_maxgo."\t";
my @parts;
sub sort_maxgo{
    my @a=split("=",$a);
    my @b=split("=",$b);
    return( scalar $b[0]<=>scalar $a[0] );
}
foreach my $mg(sort sort_maxgo values %kg_maxgo){ push @parts,$mg;}
print OUT $line,join(";",@parts),"\n";
#print "KG_MAXGO created \n";

$line="KNOWN_GENES"."\t".$known_genes."\n";
print OUT $line;

#print "KNOWN_GENES created \n";

my $note="Evidence for phenotype described by known genes created.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");
print "$time_data\n";

################################################################## FINISHED KNOWN GENES 

}


###################################################### IF GENE LIST EXISTS ###############################

my %entrezids;
if($score_genes)
{
  my $ng=scalar split(",",$score_genes); 
  my $query="call get_entrez_ids(\"$score_genes\",$ng,$organism);";
  #print "QUERY :  $query\n";  

  $sql1 = $connection->prepare($query); $sql1->execute();

## Collect the genes right away
## Fetch the gene ids
   my @row;
   while(@row=$sql1->fetchrow_array())
    { push @entrezid,$row[0]; $entrezids{$row[0]}=$row[0]; }
  
 # print "entrez ", join(" ",@entrezid),"\n";
 # my $ask=getc;


}

# While collecting gene data, we collected all genes in @all_genes;
############################################################### NOW GET THE GENE INFO AND ANNOTATIONS

my @unique_gene_ids = uniq @all_genes;
my $taxid=$taxa{$pars{"organism"}};

## CREATE A QUERY TO RETRIEVE ALL GENES FOR A GIVEN ORGANISM
my $query16 ="select geneid,symbol,description from gene_info_filt where taxid=$taxid;";
#print "QUERY :  $query16\n";
  
#print $query16,"\n";my $ask=getc;


$sql1 = $connection->prepare($query16); $sql1->execute();
while(@row=$sql1->fetchrow_array())
{  $gene_inf1{$row[0]}=join("=",@row); 
}


$sql1="";
$connection->disconnect();

my $note="Disconnected from data base.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");
system("echo \"<p>DB disconnected</p>\" >> $progress_path");
system("date >> $progress_path");

print "$time_data\n";

####################################################################
#### Here we sort the genes, then we sort by maxscore

my %gene_order;
my @sources;
my @top_genes;

# HERE ALSO MAKE SURE TO IDENTIFY MISSING VALUES
################################# SORT THE GENES : LITERATURE
 my $n=scalar keys %lit_org_genes;
if ( $n >0 )
{   
    $totals{"lit_genes"}=$n;
    my $topn=int( $n/100);

    push @sources,"lt";
    my @order;
    my $count=0;
    foreach my $g(sort byscore1 values %lit_org_genes) 
    {  
	my @gen=split(",",$g);
        my $gk=$gen[0];
        my $perc=sprintf("%.4f",100*(++$count/$n));
        my $gline=join(" ",$perc,"($count)");
        $gene_order{$gk}{"lt"}=$gline;
        $gene_order{$gk}{"list"}.=$perc.",";
        if($count<=$topn){push @top_genes,$gk;}
    }
#print "Finished sorting <br>\n";
}
################################# SORT THE GENES : HOMOLOGY ADDED
my $n=scalar keys %lit_hom_genes;
if ( $n >0 )
{   
    $totals{"hom_genes"}=$n;
    my $topn=int( $n/100);

     push @sources,"ho";
    my @order;
    my $count=0;
    foreach my $g(sort byscore1 values %lit_hom_genes) 
    {  
       	my @gen=split(",",$g);
        my $gk=$gen[0];
        my $perc=sprintf("%.4f",100*(++$count/$n));
        my $gline=join(" ",$perc,"($count)");
        $gene_order{$gk}{"ho"}=$gline;
        $gene_order{$gk}{"list"}.=$perc.",";
        if($count<=$topn){push @top_genes,$gk;}

    }

}
#print "past sorting ho\n";

################################# SORT THE GENES : KNOWN GENES
my $n=scalar keys %kg_genes;
if ( $n >0 )
{   
    $totals{"kg_genes"}=$n;
    my $topn=int( $n/100);

    push @sources,"kg";    
    my $count=0;
    my @order;
    foreach my $g(sort byscore1 values %kg_genes) 
    {  
       	my @gen=split(",",$g);
        my $gk=$gen[0];
        my $perc=sprintf("%.4f",100*(++$count/$n));
        my $gline=join(" ",$perc,"($count)");
        $gene_order{$gk}{"kg"}=$gline;
        $gene_order{$gk}{"list"}.=$perc.",";
	if($count<=$topn){push @top_genes,$gk;}
    }

}



my $note="Finished sorting.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");

system("echo \"<p>Finished sorting</p>\" >> $progress_path");
system("date >> $progress_path");
print "$time_data\n";

#############################################################
sub bypos
#############################################################
{
# subroutine sorts the list based on vectors                                                          

    my @value1=sort {scalar $a<=>scalar $b} split(",",$gene_order{$a}{"list"}); 
    my @value2=sort { scalar $a <=> scalar $b} split(",",$gene_order{$b}{"list"}); 
    my $n=scalar @value1;
    my $i;

    for ($i=0; $i<$n; $i++)
    {  if ($value1[$i]!=$value2[$i] ){last;}}
     return ( scalar $value1[$i] <=> scalar $value2[$i] );
}

my %all_genes;
my %all_genes_pos;

my @gene_table;
my @scored_gene_table;

#################################################### SORT COMBINED
#################################################### CREATE COMBINED GENE TABLE

my $ntop=int( (scalar keys %gene_order)/100);
my $count=0;

foreach my $g (sort bypos keys %gene_order)
{  
    ++$count;
    my $minval=min split(",",$gene_order{$g}{"list"});
    my $mi=join(" ",$minval,"($count)");
    my @line;
  
# if gene exists, then it means that for at least one source it was present
foreach my $s(@sources)
{  
    if( exists $gene_order{$g}{$s} ) {   push @line,$gene_order{$g}{$s};}
    else {   push @line,"100 (NA) "; }
}

my ($gid,$sym,$description)=split("=",$gene_inf1{$g});
$description=~s/_/ /g;
$description=~s/,/ /g;
$description=~s/;/ /g;
$description=~s/=/ /g;

if($count<=$ntop){ push @top_genes,$g;}
my $line=join(",",$g,$sym,$description,$mi,@line);
my $indline;
    if ( exists $entrezids{$g} ) 
     {  $indline=join(",",$line,"1"); 
        push @scored_gene_table,$indline; 
        push @top_genes,$g; # all candidates are included to get annotations 
     }
else { $indline=join(",",$line,"0"); }
$all_genes{$g}=$indline;
$all_genes_pos{$g}=$minval;

}

# take the genes that are in top_genes
sub tohash { return  %{{ map { $_ => $_ } @_ }}; }
my %topgen;
%topgen=&tohash( uniq @top_genes);

# all_genes have all and all_genes
foreach my $g (sort {scalar $all_genes_pos{$a}<=> scalar $all_genes_pos{$b}} keys %all_genes_pos)
{
    if (exists $topgen{$g}){ push @gene_table,$all_genes{$g};} 
}
my @top1_gene_table=@gene_table;
####################################################################COMBINED GENE TABLE CREATED

#print "COMBINED GENE TABLE CREATED <br>\n";

######################CREATE ANNOTATIONS FOR INSPECTION ONLY FOR GENES THAT ARE IN THE TABLES
## STORE THEM in OUT
# annot_lit
# annot_kg
# %topgen has top gene ids, we use them to take only those annotations that are associated with the top genes
# we also need annotation name, which we will take from maxgo
# The link to annotation retrieval is in create gene html table in include2
# gene_annot2.pl displays the annotations and linked d term and genes and papers 
# ev_dgo has keys ,  we use it in d_links.pl 
my @annot_lit;
my @annot_kg;
foreach my $g(keys %topgen)
{ my $line1=$annot_lit{$g};
  my $line2=$annot_kg{$g};
  push @annot_lit,$line1;
  push @annot_kg,$line2;
}

#print scalar keys %topgen,"topgen no \n";

my $line="ANNOT";
print OUT join("\t",$line,join(";",@annot_lit),join(";",@annot_kg)),"\n";
#print "ANNOT created \n";


#############################################################################################

#################################################################### MAKE HTML GENE TABLE
my @html_top1_gene_table;
my @html_list_gene_table;

#my @tbeg=&print_html_header_gene_table;
#my @tend=&print_html_footer_gene_table;
#my @tbegf=&print_html_header_small_nomargin;
#my @tend=&print_html_footer_small;


my $bgcol=1;
@html_top1_gene_table=&create_html_gene_table_new(\@top1_gene_table,\@sources,$dat,$bgcol);

$results_section{"table"}=$prog_top;
$results_section{"table_tabs"}=$tab_top;

my $line="SORTED_TOP1_COMBINED"."\t";
# we need to embrace the table
print OUT join("",$line,@html_top1_gene_table),"\n";


################################################## IF LIST EXISTS
if( scalar @scored_gene_table >0 )
{
$bgcol=2;
@html_list_gene_table=&create_html_gene_table_new(\@scored_gene_table,\@sources,$dat,$bgcol);


$results_section{"table"}=$prog_candidates;
$results_section{"table_tabs"}=join(";",$tab_candidates,$tab_top);

my $line="SORTED_LIST_COMBINED"."\t";
print OUT join("",$line,@html_list_gene_table),"\n";
}


####################################################################### Progress nore
my $note="Gene annotation information created.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");
print "$time_data\n";


######################################################################### CREATE THE OUTPUT PAGE

my @lines=&print_results(\%results_section);
my @start=&print_html_header_small($results_section{"page_title"});
my @stop=&print_html_footer_small;

#print join("\n",@lines);
#print HTML join("\n",@start,@lines,@stop),"\n";

print HTML join("\n",@lines),"\n";

close(HTML);
close(OUT);

#################################### Finished Processing 

my $note="Created results page.";
my $time_data=&time_note($note);
system("echo \"$time_data\" >>  $progress_path");
print "$time_data\n";

exit(0);


