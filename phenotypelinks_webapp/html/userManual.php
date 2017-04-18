<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Phenotype Links Tool: User Manual</title>  
  <meta name="description" content="website for gene prioritization">
  <meta name="keywords" content="phenotype,gene,prioritization">
  <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">

<link rel="stylesheet" type="text/css" href="http://phenotypelinks.net/browse/style/caroline/style_header_for_pageResults.css">
<!--
  <link rel="stylesheet" type="text/css" href="http://phenotypelinks.net/browse/style/ep_links.css">
-->
  <meta content="Erinija Pranckeviciene" name="author">

</head>
<body>

 <div style="width: 100%;">

<!-- Main header
--> 
 <div id="main" style="margin-bottom:0;">

  <a href="http://phenotypelinks.net/browse/index.php" target="_self"><h1><span class="alternate_colour">Phenotype Links </span> tool
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

<h1 style="text-align:left;" class="main_menu"><a style="color: #444;" href="mailto:epranckeviciene@ohri.ca"> Contact us </a></h1>

<!-- end of Main menu -->

</td>

<!-- main content -->
<td style="width:84%;vertical-align:top;background-color:white;">

<p style="font-size:larger;text-align:justify;margin-top:10px;margin-left:20px;margin-right:20px;margin-bottom=0px; padding-bottom:0px;"> 
<h1 id="toc">User Manual</h1>
<h1 id="toc">Table of Contents</h1>
<h3><a href="#intro">1. Introduction to the Phenotype Links Tool</a></h3>
<h3><a href="#user_input">2. User Input</a></h3>
<!--<h3><a href="#querying_example">Querying Example</a></h3>
-->
<h3><a href="#processing">3. Processing</a></h3> 
<h3><a href="#list_genes">4. List of Prioritized Genes</a></h3>
<h3><a href="#evidence_literature">5. Evidence derived from Literature</a></h3>
<h3><a href="#evidence_contextg">6. Evidence derived from Context Genes</a></h3>


<h1 id="intro">1. Introduction to the Phenotype Links Tool</h1>
<p><a href="#toc">Back to the Table of Contents</a></p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
Often molecular biologists have to analyze poorly characterized gene lists obtained in Microarray or Next Generation Sequencing or other experiments. The smaller number of the candidate genes, strongly related to the phenotype of interest, should be selected from the large list. Most of the current gene prioritization tools for phenotype definition use genes with known functions for phenotype definition. Our Phenotype Links Tool  provides the functionality absent in the currently available gene prioritization tools such as the phenotype definition by the meaningful keyword. To define the phenotypes, we use the <a href="http://www.nlm.nih.gov/mesh/2012/mesh_browser/DCMS/MBrowser.html" target=_blank> Medical Subject Header (MeSH)</a> terms. The MeSH terms are created by the National Library of Medicine (NLM) to annotate a content of the articles in the MEDLINE database by manual curation. Our system deduces the relationships between the phenotype and the functional <a href="http://www.geneontology.org/" target=_blank>Gene Ontology</a> annotations of the genes. The strength of these relationships is used to prioritize the genes in the list of candidates. We utilized a computational algorithm similar to the algorithm in the <a href="http://www.ogic.ca/projects/g2d_2/" target=_blank> G2D </a> (genes to diseases) system.
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
Our algorithm assigns weights to the Gene ontology (GO) annotations that express a strength of the connection between a gene feature and the phenotype. Large weights encode strong connections. Annotated genes are ranked by the weights of their annotations from the most promising to the least promising. Towards the top of the ranked gene list we expect to find genes that are strongly connected to the phenotype, based on the current state of knowledge in the literature. The Homology between the genes of the different organisms can be used as an additional data source. If so, then the weighted gene annotations from the other organisms are included into the prioritization process. The user can also define the phenotype by a the context genes with the known functions. The annotations of the context genes are used to weight all other GO annotations by the semantic Resnik similarity.
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
 We rank the whole genome of the selected organism separately for each selected data source. The gene ranks are transformed into a relative score also known as a rank ratio. The lesser is the relative score, the better the candidate gene is. A combined relative score of the gene is the best relative score out of all scores corresponding to the provided data sources. As a result of the prioritization, the  genes sorted by the combined relative score are listed.
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;"> 
We tested our tool by using the gene sets from <a href="http://www.informatics.jax.org/" target=_blank>Mouse Genome Informatics (MGI)</a> database. For the algorithmic details, estimation of the performance and a list of references we refer the user to the <a href="http://phenotypelinks.net/browse/tr.pdf">Technical Manual</a>. The User Manual describes the main features of the Phenotype Links Tool user interface.</p> 


<h1 id="user_input">2. User Input</h1>
<p><a href="#toc">Back to the Table of Contents</a></p>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;"> The user input interface is shown in Figure 1. To explore the tool you can click on the link Cell Movement phenotype example, in which the input fields will be filled automatically, then submit the example and explore the output.  Our tool requires user to provide the phenotype definition either by the MeSH term or by the known genes or both. The mandatory elements of the input consist of:
<ol style="text-align:justify;font-size:larger;">
<li>the organism,</li>
<li>whether the homology information is included,</li>
<li>the phenotype description.</li>
</ol>
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
 The phenotype description by the MeSH term consists of the text phrase, whch matches the MeSH term exactly. Our tool supports the phenotypes described by the <a href="http://www.nlm.nih.gov/mesh/2012/mesh_browser/MeSHtree.G.html#link_id" target=_blank> MeSH terms</a> of the categories G (Biological Phenomena and Processes), C (Diseases), D (Chemicals and Drugs) and A (Anatomy) in 2012 edition of the MeSH Vocabulary. The alphabetically ordered summary of the MeSH keywords that can be used for the phenotype definition can be reviewed here.
</p> 
<p><b>Figure 1. User Input Area</b></p>
<img src="img/inputs.png" alt="User Input Page" width="850px" height="500px" border="1" bordercolor="blue"> 
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;"> 
Select the organism from the list field. If you choose to use homology information btween the organisms, check the Homology box.<br><br>
In the Step 1 field OPTION 1 type the text phrase corresponding to the MeSH term, which describes your phenotype.<br><br>
In the OPTION 2  list the context genes separated by <u>space</u>, defining your phenotype. If the list of the context genes is large, then you can upload the text file with the gene symbols. The text file has only one column as shown in the Querying Example. Both the OPTION 1 and the OPTION 2 can be used to describe your phenotype.<br><br>
In the Step 2 provide  the list of the candidate genes that you wish to prioritize. If the Step 2 is ommitted, then the Top 1% of the ranked genome is displayed as a result.<br><br>

Typical response time is about 3 minutes. If you wish to process your query faster, then check the box for faster processing. The Reset button clears all fields. Click on the Submit button to pass your query for processing.</p>

<h3 id="querying_example">Example of the query. Score a list of  genes for association to cell movement phenotype.</h3>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">

1) <b><u>Input the phenotype</u></b>: MeSH term for this phenotype is "cell movement".
If not sure, then use the link <a href="http://www.nlm.nih.gov/mesh/2012/mesh_browser/MBrowser.html" target="_blank">Find Mesh</a> and find most appropriate term for your phenotype. In the MeSH term field the input: cell movement contains <b> text only </b> separated by spaces, no special symbols, unless the mesh term has them.
<br><br>
2) <b><u>Selecting organism</u></b>: Currently we support only mouse, human and fly.
<br><br>
3) <b id="uploading"><u>Uploading file</u></b>: Upload the gene list, which you would like to score.
It should be a simple text file  with one column. List the gene identifiers starting at the first row. The gene symbols should be <a href="http://www.ncbi.nlm.nih.gov/gene/" target="_blank"> NCBI Gene </a> symbols, not synonyms. We map them into Entrez GeneIDs. The example gene column in the file <a href="http://phenotypelinks.net/browse/cell_movement.txt" target=_blank>cell_movement.txt</a> opens in the new window. It contains mouse genes from <a href="http://www.informatics.jax.org" target="_blank">MGI</a> associated with the cell movement phenotype. You can copy paste this column into a text file on your local computer, and then upload to try this example. <b>Note</b>. If gene list is not provided, then the whole genome of the selected organism will be ranked and the top scoring genome genes in the Top 1% of the ranked genme will displayed.
</p>

<h1 id="processing">3. Processing</h1> 
<p><a href="#toc">Back to the Table of Contents</a></p>
<p  style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The query processing pipeline consists of interrogating our database, sorting the genome of the provided organism based on the information for each data source and creating the report. The completion of every processing step is displayed in the progress page as shown in Figure 2. To open the report with the results click on the provided link <b>Your results are </b><u>here</u>.
</p>
<p><b>Figure 2. Progress Display</b></p>
<img src="img/progress.png" alt="Progress Page" width="350px" height="300px" border="1"> 

<h1 id="list_genes">4. List of Prioritized Genes</h1>
<p><a href="#toc">Back to the Table of Contents</a></p>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The result of the gene prioritization is shown in Figure 3. The list of the candidate genes will be displayed in the prioritization table, if you have submitted the list of the gene candidates. Alternatively the Top 1% of the ranked genome will be shown. The user can switch betwee these views by clicking on the links <u>Candidate Genes</u> or <u>Top Ranked Genome</u>. 
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The columns in the prioritization table show the ranks of the genes in the whole genome for each selected data source. By clicking on the header of the column, the user can sort the rows by the gene ranks. The gene ranks are assigned by sorting the weighted GO annotations of the gene. The genes having GO annotations with the large weight will be at the top of the ranked list. In the <b>Literature</b> column the genes are ranked by the GO weights expressing the strength of the connection between the GO annotation and the MeSH keyword defining the phenotype. In the <b>Homology+</b> column the ranking is performed using all weighted GO annotations of the homologous genes. In the <b>ContextGenes</b> column the genes are ranked by the GO weights semantically most similar to the GO annotations of the context genes. The details of the weight computation can be found in <a href="http://phenotypelinks.net/browse/tr.pdf">Technical Report</a>.
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
 The gene ranks are represented by the relative score also termed as a rank ratio. The relative scores (rank ratios) are computed by dividing the  gene position in the ranked whole genome by the total number of the ranked genome genes. The relative scores are given a preference to the gene positions in the ranked gene lists. The relative scores allow to compare the gene positions in the ranked lists of the variable size.The smalle relative scores indicate strong relationship between the gene candidate and the phenotype. The gene position in the ranked whole genome is shown in the brackets next to the relative score. The genes in the table are sorted by the <b>CombinedScore</b>. The <b>CombinedScore</b> is the best (minimum) score out of the all individual scores
</p>

<p><b>Figure 3. Prioritization Results for the Candidate Genes</b></p>
<img src="img/gene_list.png" alt="Gene list" width="850px" height="480px"  border="1"> 

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
Click on the gene symbol to see the weighted gene annotations (Figure 4) that led to the current ranking of the genes. The link on the gene description opens the  NCBI page of that gene. Examine the reasons for the association between the genes and the phenotypes by clicking on the links <u>Literature</u> and/or the <u>Context Genes</u> below the prioritization table.  
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
By clicking on the gene symbol in the gene prioritization table the user can examine the weighted gene ontology annotations. They are shown in the panel <b>Weighted GO annotations</b> in Figure 4. Left table shows the weighted GO annotations that received their weight from the associations of the MeSH Terms in  MEDLINE. The right table shows the annotations for which the weights were estimated by the similarity to the functional annotations of the Context Genes. The first row in each table contains the GO annotation with the maximum weight. The maximum weight was the first value, contributing to the obtained rank of the gene.The annotation tables contain detailed information about the sources that contributed to the weights of the annotations.</p>
<p style="text-align:justify;font-size:normal;margin-left:20px;margin-right:40px;">
Contents of the table <b>Annotations weighted by Literature</b>:
<table style="width:95%;border: 1px solid;margin-left:20px;margin-right:40px; cell-padding:10px;cell-spacing:5px;">
<tr style="border: 1px solid;">
<th style="border: 1px solid;">Column</th><th style="border: 1px solid;">Description</th>
</tr>
<tr style="border: 1px solid;">
 <td style="border: 1px solid;"><b>GO score</b></td><td style="border: 1px solid;"> the weight of the GO annotation used in the gene ranking</td>
</tr>
 <td style="border: 1px solid;"> <b>GO term</b></td><td  style="border: 1px solid;">the annotation description</td>
</tr>
<tr style="border: 1px solid;">
 <td style="border: 1px solid;"><b>Organism</b></td><td style="border: 1px solid;">the organism that contributed this GO annotation, either the human or mouse or fly</td>
</tr>
<tr style="border: 1px solid;"> 
 <td style="border: 1px solid;"><b>GO-MeSH D Score</b></td> <td style="border: 1px solid;">the value of the strength of the connection between the GO annotation and the MeSH D term which designates the molecular entity; This value is computed from the frequency of the co-occurrence of the GO annotation and the MeSH D term in the NCBI <i>gene2go</i> and <i>gene2pubmed</i> databases</td>
</tr>
<tr style="border: 1px solid;">
 <td style="border: 1px solid;"> <b>MeSH D Term</b></td><td style="border: 1px solid;">the name of the MeSH D term with strongest connection to that GO annotation</td>
</tr>
</table>
</p>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The <b>GO score</b> is derived from the  <b>GO-MeSH D Score</b> and the strength of the connection between the phenotype and that particular  <b>MeSH D Term</b>. You can explore these relationships between the phenotype and linked <b>MeSH D Terms</b> by examining the evidence derived from the literature (link <u>Literature</u> in Figure 3).<br>
 The table on the right represents the annotations in which the  weights were computed by estimating the semantic similarity between the functional annotations of the <b>Context Genes</b> and all other GO  annotations in the whole GO database. </p>
<p style="text-align:justify;font-size:normal;margin-left:20px;margin-right:40px;">
Contents of the table <b>Annotation scored by Resnik similarity</b>:
<table style="width:95%;border: 1px solid;margin-left:20px;margin-right:40px; cell-padding:10px;cell-spacing:5px;">
<tr>
<th style="border: 1px solid;">Column</th><th style="border: 1px solid;">Description</th>
</tr>
<tr>
<td style="border: 1px solid;"><b>Resnik Score</b></td><td style="border: 1px solid;">the value of the maximum semantic similarity</td>
</tr>
<tr>
<td style="border: 1px solid;"><b>GO Term</b></td><td style="border: 1px solid;">the name of the GO annotation</td>
</tr>
<tr> 
<td style="border: 1px solid;"><b>Organism</b></td><td style="border: 1px solid;">the organism of the gene contributing that annotation</td>
</tr> 
</table>
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
 You can explore the GO annotations most contributing to the semantic similarity scores  by examining the evidence derived from the Context Genes (link <u>Context Genes</u> in Figure 3).
</p>

<p><b>Figure 4. Display of the weighted gene annotations</b></p>
<img src="img/annotations.png" alt="Weighted annotations" width="850px" height="500px"  border="1"> 


<h1 id="evidence_literature">5. Evidence derived from Literature</h1>
<p><a href="#toc">Back to the Table of Contents</a></p>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The user can examine the relationships between the MeSH terms and GO annotations that led to the current gene prioritization. The evidence page <b>Links for phenotype derived from literature</b> is shown in Figure 5. There are two tables and the panel at the bottom. By browsing through the evidence tables the user can see what are the most important links between the concepts, underlying the obtained gene proritization.  
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The left table shows the MeSH terms of the category D (chemicals and drugs) that have the strongest connections to the phenotype of interest. The strength of these connections is derived from the frequencies of the MeSH annotations occurring together in the MEDLINE articles. The column <b>MeSH D Score</b> represents the actual value of the strength of the relationship. The <b>MeSH D Term</b> identifies the particular MeSH annotation. By clicking on the MeSH D annotation the user can explore this term in the NCBI MeSH database. The link <u><font style="color:blue"> << </font></u> opens Pubmed articles, that led to the relationship between the phenotype and that particular MeSH D. The MeSH D terms are linked to the GO annotations. By clicking on <u><font style="color:blue"> v </font></u> the user will display  all GO annotations connected to this particular MeSH D in the bottom panel <b>Links between the MeSH D and the GO annotation</b>. 
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The right table represents the GO annotations most strongly connected to the phenotype through the MeSH D terms. The column <b>GO Score</b> shows the actual weight of the GO annotation used in the gene ranking. The GO annotation link opens a new window displaying information in the Gene Ontology database. By clicking on the  <u><font style="color:blue"> v </font></u> in the <b>Linked MeSH D</b> column, the user displays all MeSH D terms, associated with that particular GO in the bottom panel  <b>Links between the MeSH D and the GO annotation</b>. In Figure 5 in the bottom panel the MeSH D terms are listed that were linked to the GO term <font style="color:brown"> regulation of tolerance induction to self antigen </font>. The column <b>Cell Movement-MeSH D</b> in the bottom table indicates the strength of the connection between the <b>Cell Movement</b> phenotype and the MeSH D term. The column <b>MeSH D-GO Score</b> shows the strength of the relationship between the  <font style="color:brown"> regulation of tolerance induction to self antigen </font> and each linked MeSH D term.
</p> 

<p><b>Figure 5. Evidence from Literature</b></p>
<img src="img/literature.png" alt="Evidence from Literature" width="850px" height="450px" border="1"> 


<h1 id="evidence_contextg">6. Evidence derived from Context Genes</h1>
<p><a href="#toc">Back to the Table of Contents</a></p>

<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The page <b>Evidence for Phenotype defined by context genes</b> in Figure 6 shows the Gene Ontology annotations that provided semantic similarity scores for other GO terms. The listed GO annotations represent the most informative common ancestors in the taxonmy of the Gene Ontlogy. The most informative common ancestors relate the annotations of the <b>Context Genes</b> and all ather GO annotations in the whole database. The context genes defining the phenotype are shown in the top panel.
</p>
<p style="text-align:justify;font-size:larger;margin-left:20px;margin-right:40px;">
The <b>Score</b> column indicates the information content (IC) assigned to the GO annotation. The IC is computed as a negative logarithm of the ratio of the number of genes annotated by that GO term and all it's descendants to the number of all annotated genes. If the GO term is very specifc, then it annotates just few genes and has very high information content. High information content of the annotation indicates that alldescendants of this annotation in the taxonomy will be very informative as well. They all will have high GO <b>Scores</b>, which are used to rank the genome genes. The genes very similar functionally to the context genes will be ranked very high.  
</p>


<p><b>Figure 6. Evidence from Context Genes</b></p>
<img src="img/context_genes.png" alt="Evidence from Context Genes" width="850px" height="450px" border="1"> 



<p><a href="#toc">Back to the Table of Contents</a></p>


</td>
</tr>
</table>


<!--
<p class="center"> <a href="http://www.ohri.ca/" target="_blank"> </a>, <?php echo " ".date("Y M d"); ?> </p>
-->
<!-- 100% div 
-->
</div>

</body>
</html>
