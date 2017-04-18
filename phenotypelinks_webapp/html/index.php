<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Phenotype Links</title>  
  <meta name="description" content="website for gene prioritization">
  <meta name="keywords" content="phenotype,gene,prioritization">
  <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">

   <link rel="stylesheet" type="text/css" href="http://phenotypelinks.net/browse/style/ep_links.css">

  <meta content="Erinija Pranckeviciene" name="author">

<!-- Javascript added by Caroline Louis-Jeune -->
<script type="text/javascript">

//To clear the form
function formReset()
{
	document.getElementById("user_phenotypeform").reset();
}

//Fill the form with the example data upon the clicking of "Cell Movement phenotype example"
function addCellExample()
{

	document.getElementById("meshTermInput").value = "cell movement";
	document.getElementById("knownGenesInput").value = "Casp1 Cav1 Icam1 ";
	document.getElementById("scoreGenesInput").value = "Muc2 Myh9 Nckap1 Ncoa3 Pax5 Dock2";

}

</script>
<!---->

</head>
<body>

 <div style="width: 100%;">

<!-- Main header
--> 
 <div id="main" style="margin-bottom:0;">

 <a href="http://localhost/index.php" target="_self"><h1><span class="alternate_colour">Phenotype Links </span> tool
</h1></a>

 <br>
 </div>

<!--   Main header end 
-->
<!-- Following main header comes table with two columns
     Left side is about and useful links
     Right side is description and sections of input fields
-->
<div style="width:100%;margin-left:10px;margin-top:0px;margin-right:50px;">


<!--   Main section starts -->
<table style="width:98%;cellspacing=0;cellpadding=0;margin:0; background-color: #E9E4C7;">
<tr>
<td style="width:16%;text-alignment:left;vertical-align:top;background-color: #E9E4C7;">

<!-- Main menu -->
 <br>
 <h1 style="text-align:left;">About</h1>
    <ul  style="text-align:left;" class="main_menu">
      <li><a href="http://phenotypelinks.net/browse/userManual.php" target="_self">User manual</a></li>
      <li><a href="http://phenotypelinks.net/browse/all_benchmark_results.xls" target="_blank">Benchmark</a></li>
    </ul>
 
 <h1 style="text-align:left;">Useful links</h1>
     <ul  style="text-align:left;" class="main_menu">
      <li><a href="http://www.ncbi.nlm.nih.gov/gene" target="_blank">NCBI Gene</a></li>
      <li><a href="http://www.geneontology.org/" target="_blank">Gene Ontology</a></li>
<!--          <li><a href="http://www.genecards.org/" target="_blank">Gene Cards</a></li>
-->
      <li><a href="http://homes.esat.kuleuven.be/%7Ebioiuser/gpp/" target="_blank">Gene Prioritization Portal</a></li>
    </ul>

<h1 style="text-align:left;" class="main_menu"><a style="color: #444;" href="mailto:erinija.pranckeviciene@gmail.com"> Contact us </a></h1>

<!-- end of Main menu -->

</td>

<!-- main content -->
<td style="width:84%;vertical-align:top;background-color:white;">

<p style="font-size:larger;text-align:justify;margin-top:10px;margin-left:20px;margin-right:20px;margin-bottom=0px; padding-bottom:0px;"> With our tool you can prioritize a list of genes of human, mouse and fly organisms  with respect to your phenotype of interest. The  phenotype is defined by MeSH keyword and/or by a list of known genes. We order genes by weights of the Gene Ontology (GO) annotations, which are most connected to your phenotype, defined by MeSH. The connections are derived from the whole  MEDLINE. If your phenotype is defined by the known context genes, then the GO annotations are weighted by the Resnik distance to the context annotations. Homology between the organisms can be used as complementary information. Find more in User manual. Typical response time is about 2-3 minutes. Faster processing applies stringent information filter and you may loose some links. To explore our tool, click on the following <a href="#" onclick="addCellExample()">Cell Movement phenotype example</a> and then submit to see the results. 
</p>
<br>
<h1 style="text-align:center;vertical-align:top;color:brown;margin-top:0px;padding-top:0px;">Your query</h1>
<hr>
<!-- FORM SECTION -->

<form id="user_phenotypeform" enctype="multipart/form-data" method="post" action="http://408847.s.dedikuoti.lt/cgi-bin/readform3.cgi" target=_blank>
 
	<p style="vertical-align:top;text-align:center;"> Organism 
		<select name="organism">
   			<option selected="selected">mouse</option>
   			<option>human</option>
   			<option>fly</option>
		</select>

		&nbsp;Homology&nbsp; <input name="homology" type="checkbox">
		<!--&nbsp;Homology&nbsp; <input checked="checked" name="homology" type="checkbox">-->
	</p>

<!-- table for input fields -->
<table style="width:100%;cellspacing=0;cellpadding=5;">
<!-- this table has 4 rows with two columns: description and input fields-->
<tr>
	<!-- HEADER -->
	<th colspan=2 ><h2 style="color:white;"><b>STEP 1</b></h2></th>
</tr>
<tr>
<td style="width:35%;background-color:#E6E6E6;vertical-align:top;padding-left:10px;padding-right:10px; padding-top:10px;">
<h5 class="center"><b>Option 1:</b> Define phenotype by MeSH Term</h5>
 <p style="text-align:justify;"> Input below a MeSH term of category G (Biological Processes
and Phenomena) or C (Diseases), which describes your phenotype the best.
 For example:<b> cell cycle</b> or <b>tremors</b>. Use <a href="http://www.nlm.nih.gov/mesh/2012/mesh_browser/MBrowser.html" target="_blank">Find Mesh</a> link to find appropriate term, which best describes your phenotype of interest.
  </p>
<p style="text-align:left;">
	Mesh term&nbsp;
  	<input name="mesh" id="meshTermInput">
</p>
</td>

<td style="width:35%;background-color:#D9D9D9;vertical-align:top;padding-left:10px;padding-right:10px; padding-top:10px;">
<h5 class="center"><b>Option 2:</b> Define phenotype by Known Genes</h5>
<p  style="text-align:justify;"> Provide a list of known genes that
 describe your phenotype. List the genes by HUGO symbols
separated by space as: Cdk2 Cdk4 Trp73. Alternatively you can upload
 a text file with the gene list as a single column in the file.
</p>
<p style="text-align:left;">
File&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <input name="known_genes_file" type="file">&nbsp;&nbsp;&nbsp;<a href="http://phenotypelinks.net/browse/userManual.php#uploading" target="_self">?</a>
<br><br>
<font style="vertical-align:top;">Genes</font>&nbsp;&nbsp;
  <textarea cols="25" rows="1" name="known_genes_symb" id="knownGenesInput"></textarea>
</p>
</td>
</tr>

<tr>
	<!-- HEADER -->
	<th colspan=2 ><h2 style="color:white;"><b>STEP 2 (optional)</b></h2></th>

</tr>

<tr>
<td style="width:35%;background-color:#CCCCCC;vertical-align:top;padding-left:10px;padding-right:10px; padding-top:10px;" colspan=2>
<h5 class="center"> List candidate genes</h5>
 <p  style="text-align:left;"> Provide a list of gene candidates that you wish to
prioritize.For few genes list the gene symbols separated
by space.<br>Upload a large set in a text file, gene symbols listed in a single column. If you don't have candidate list, then by default the Top 1% of the whole ranked genome will be shown.
</p>
<p id="para1" style="text-align:left;">
	
	 File&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <input name="score_genes_file" type="file">&nbsp;&nbsp;&nbsp;<a href="http://phenotypelinks.net/browse/userManual.php#uploading" target="_self">?</a> 
	<br><br>
	<font style="vertical-align:top;">Genes</font>&nbsp;&nbsp; 
	  <textarea cols="25" rows="1" name="score_genes_symb" id="scoreGenesInput"></textarea> 
</p>
</td>
</tr>
<!-- end of description and input row-->
</table>

<!-- the table with input fields ends -->
<p style="text-align:center;">  

<input name="fast" type="checkbox">&nbsp; Check for faster processing &nbsp; 
<!--<input name="fast" type="checkbox" checked="checked">&nbsp; Check for faster processing &nbsp;--> 

</p>
<hr>

<!-- SUBMIT/RESET buttons -->
<p class="center">
	<!-- SUBMIT button -->
	<input name="submit" value="Submit your query" type="submit">&nbsp;&nbsp; 

	<!-- RESET button -->
	<!--<input name="reset" type="reset" onclick="formReset()">-->
	<input name="reset" type="reset">
</p>

</form>
<!--  END of FORM SECTION -->




</td>
</tr>
</table>

</td>
</tr>
</table>
<p class="center">  &nbsp; CSS &nbsp;by C.Luis-Jeune, &nbsp; &nbsp;&nbsp;<?php echo " ".date("Y M d"); ?> </p>

<!-- 100% div 
-->
</div>

</body>
</html>
