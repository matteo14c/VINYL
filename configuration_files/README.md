# Configuration files and parameters

*VINYL* requires several configuration files for the calculation of its pathogenicity score. Although some of these files are not mandatory, it is highly recommended to incorporate into VINYL as much information as possible in order to obtain high levels of sensitivity and accuracy. An example of each of type  of configuration file can be found at in the Galaxy implementation of VINYL, at the following link: http://90.147.75.93/galaxy/library/list#folders/Fb04ca61b52e20534 or in the present folder. 
A description of the configuration files and  the input parameters of VINYL is provided in the following section.

## Keywords configuration files
VINYL uses different sources of annotation for the computation of its pathogenicity score, users can specify the type and the list of resources to be used by the means of  the “keywords” configuration file. This is a configuration file that specifies the keywords that are used by VINYL for the extraction of relevant annotations from VCF files and for the computation of the pathogenicity score. Names of these keywords need to match exactly those used by Annovar (Wang et al 2019). Currently VINYL discriminates between 8 different types of "keywords", which are used to calculate different components of the score. see supplementary Table 1 and supplementary Table 2, for a complete description of the resources available in VINYL. 

* AF keywords: specify the databases/resources that are used to obtain Allele Frequency annotations. When multiple resources  are provided the maximum value is considered
* NStool keywords: specify the tools for the evaluation of the functional effects of Non Synonymous variants that are considered by VINYL for the computation of the Disruptive non synonymous variants score. More than one tool can be specified. 
* Effect keywords: these keywords set the columns that are used by VINYL to extract the predicted annotation of the functional effects of the variants. If values associated with these keys match any of the deleterious effects as listed in the functional effects file (see below) the pathogenicity score is incremented
* Splice keywords: specify the databases/resources that are used to evaluate the effects of genetic variants on splice site. In the current implementation of VINYL these correspond with the dbscSNV_ADA_SCORE and the dbscSNV_RF_SCORE. Both scores are derived from the dbscSNV database (Jian et al, 2014)
* Reg keywords: specify the databases to be considered for the annotation of regulatory regions. Defaults to ORegAnno_REGULATORY_R and ENSEMBLReg. The nCER90 and nCER95 databases can be specified as well.
* tfbs keywords: specify the databases to be considered for the annotation of Transcription Factor Binding sites regions. Defaults to ORegAnno_REGULATORY_TFBS and ENSTFBS
* mirna keywords: specify the databases to be considered for the annotation of miRNA binding sites. Defaults to ENSmiRNA and ORegmiRNA
* gwas keywords: these keywords are used to indicate the resources to be used for the annotation of SNPs implicated with phenotypic traits of interest as specified in the “symptoms” configuration file (see below) according to a Genome Wide Association Study. At the time being, the annovar database incorporated in VINYL includes only one resource for this type of annotation, the GWAS reference database, as obtained from https://www.ebi.ac.uk/gwas/https://www.ebi.ac.uk/gwas/ (Buniello et al, 2019)

The format of the keyword file is very simple: this a plain tabular file where each keyword (be aware that the names should match exactly the names used by Annovar) is followed by a qualification that specifies its type. As outlined above types can be any of: AF, Effect, NStool, Spliece, Reg, tfbs, mirna, and gwas.	kfile3 is a valid example of a keywords file.	 	

## Predicted functional effects
Predicted functional effects which should be considered deleterious, can be specified by the means of the functional effects configuration file (efile). The file has a very simple format: each functional effect is provided in a separate line. The convention used to indicates these effects is the same as that applied by Annovar (Wang et al 2010). Please refer to the Annovar documentation for a thorough explanation of the annotation of predicted functional effects by Annovar. 	efile is a valid example of a functional effetcs configuration file.

## Symptoms file
Symptoms of the pathological condition under study, can be specified by the symptoms configuration file. This file provides a list of symptoms or related keywords that are used by VINYL to screen Clinvar (Laundrum et al, 2014) Annotations and identify variants that have been implicated in similar pathologies or phenotypes. The file is provided in a simple text format, where each of the keyword needs to be reported on a separate line. See  sfile for an example of a valid file. Users are encouraged to check the controlled vocabulary of names and symptoms associated with the pathological condition of interest in the OMIM database (Amberger et al, 2019). 

## List of genes files
A list of genes previously implicated in the pathological condition under study can be specified via the gene list configuration file (see DCM_genes in the present folder). The file is in simple text format, with each gene reported on a separate line. Genes are indicated by their official gene symbol.

## List of tissues of eQTL annotation
List of tissues to be considered for the analysis/annotation of expression Quantitative Trait Loci (eQTL) can be specified through the “eQTL” configuration file. Names of tissues need match names used in the GTEx project  (GTEx Consortium, 2013). Again, this is simple text file with the name of the tissues in a separate line. See qfile for an example. 	
