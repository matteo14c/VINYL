# VINYL
scripts, tools and example configuration files for VINYL
This Github repositories contains all the scripts required to run VINYL (Chiara et al,2020) an automated system for variant priotitization. The repo is divided into the following folders:
1) core -> contains the "core" script, including the scripts used for scoring of the variants, optimization of the pathogenicity score and identification of the ideal cut-off score
2) PCA -> utilities to perform PCA analysis of VINYL scores.
3) boxplot-> utilities for the comparison of VINYL scores on a gene by gene basis (similar to burden testing)
4) configuration files -> examples of valid configuration files
5) input -> 2 example input files

VINYL is implemented as a collection of Perl and R scripts. So in order to execute it, all you need is a working installation of R and Perl. Optimization of the pathogenicity score is performed through the "genalg" implementation of genetic algorithm. Therefore you will also need to install the genalg library in your R installation. 
See: https://cran.r-project.org/web/packages/genalg/index.html

VINYL required as its main input vcf files annotated using the annovar program. Annovar is available from:  (http://annovar.openbioinformatics.org/en/latest). 
Please refer to the documentation of annovar for how to install, use and configure this tool. For you convience you can download all the resources that are currently incorporated into the annovar database included in the Galaxy instance of VINYL, by anonymous ftp at the following address: 90.147.75.93. To access the files you can use your favourite ftp client, and specify "anonftp" as the username. For example if you use the ncftp client, you can access the repo by using the command <ncftp ftp://anonftp:@90.147.75.93> . You will be asked for a password, but no password is required and you can simply hit enter, to access the repository. You can get any file (or all of them) simply by using the "get" command.
A valid command for the annotation of a VCF vile to be submitted to VINYL, looks is something like this:

<table_annovar.pl Sorrentino_etal2017.vcf  /annovardb/HumanDBAnnovar/ --vcfinput -buildver hg19 -remove -protocol refGene,GWAS,nCER95,ORegAnno_REGULATORY_R,ORegAnno_REGULATORY_TFBS,ORegmiRNA,ENSTFBS,ENSmiRNA,ENSEMBLReg,gnomad211_genome,exac03nontcga,dbnsfp35a,avsnp150,kaviar_20150923,esp6500siv2_ea,1000g2015aug_all,dbscsnv11,clinvar_20190305,Heart_Atrial_Appendage,Heart_Left_Ventricle -operation g,f,r,r,r,r,r,r,r,f,f,f,f,f,f,f,f,f,f,f -nastring . -outfile Sorrentino_etal2017_annovar>

Please feel free to use the online Galaxy implementation of VINYL if you are not confortable with annovar and/or command line tools in general

Please refer to the README file in each folder for a more detailed description of all the modules of VINYL
