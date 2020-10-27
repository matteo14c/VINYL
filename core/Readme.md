# Prerequisites

#################################################################################################################
IMPORTANT for these scripts to work you need to have a copy of the GENEO_VINYL.R R script and of the Perl script *score_complete_alt_M.pl* in you ~/bin directory.  Both programs are invoked "internally" by optimizer_genetic.pl, which expects to find them in the bin directory in your home. 
#################################################################################################################

This folder contains the core utilities required to run VINYL. These are the: 
* "optimizer": optimizer_genetic.pl the script that is required for the computation of the optimal VINYL score, 
* the score_complete_alt_M.pl script, which is used to compute scores from VCF files, 
* and the survival_M.R script which is used to derive the optimal score cut-off for identifying likely pathogenic variants. 

For these utilities to work (see also above) you need to have a copy of both GENEO_VINYL.R and score_complete_alt_M.pl in the bin directory of your account. Alternatively you can modify the $exec_path variable in line 5 of  optimizer_genetic.pl and line 28 and 29 of GENEO_VINYL.R, to reflect the absolute paths of these scripts.

Normally, to execute a complete analysis you will need to:
  
1. Run the optimizer through optimizer_genetic.pl. The output file will consist in a table with the "optimal" weights for the computation of the VINYL pathogenicity score
  
2. Execute the score_complete_alt_M.pl with the score weights identified at the previous point (the first non-header line of the output file of the optimizer), to compute vinyl score for both the vcf of the affected individuals and the control population
  
3. Use the survival_M.R script to derive the optimal cut-off value.
 
Please feel free to refere to Chiara et al 2020 and to http://90.147.75.93/galaxy/static/manual/ for a more detailed description of the logic behind VINYL and the implementation of the algorithm.
A more detailed description of the parameters used, of the configuation files and of their usage, can be found again at  http://90.147.75.93/galaxy/static/manual/ or in the supplementary materials of Chiara et al, 2020.

## Execution of the VINIL optimizer.

The VINYL optimizer utility is executed by the means of the optimizer_genetic.pl Perl script. This script call directly or indirectly both by the score_complete_alt_M.pl and the GENEO_VINYL.R utilities for the computation and for the optimization of the score respectively. 
*Please make sure that this files are in your ~/bin folder, or modify the scripts accordingly (see above).*

The main inputs consist in 2 vcf files annotated by annovar. (see main Readme).
These are provided by the *-fileR* (affected) and by the *-fileC* (controls) option
The name of the output file (which is in tsv format) can be specified by the *-ofile option*. If the name is not specified, the default value "VINYL.ofile" is used.

Additional parameters can be used to specify the ranges (minimum and maximum values) for the variuos components of the vinyl scores, and the configuration files and options to be used.
### Parameters for the configuration of VINYL include: 
  
* -disease  ->     description of the pathological condition. Multiple keywords can be separated by #
* -similarD ->     name of the "sfile" (see configuration files)
* -lgenes   ->     name of the "lgenes" (see configuration files)
* -leQTL    ->     name of the "eqtl" (see configuration files)
* -keywords ->     name of the "kfile" (see configuation files)
* -effects  ->     name of the "efile" (see configuation files)
* -AF       ->     allele frequency cut-off for rare variants, should reflect the prevalence of the disease
* -nind     ->     cut off for the over-representation score (see Chiara et al 2020 and the online manual)
* -AD       ->     is the disease autosomic dominant T/F
* -XL       ->     is the disease autosomic x-linked T/F

### Parameters for the configuration of score values include:
  
* -disease_clinvar  -> score for genetic variants implicated in the pathological condition according to clinval
* -score_AF         -> score for rare variants
* -score_functional -> score for variants with a predicted deleterious effect
* -score_NS         -> score for ns variants with a  predicted disruptive effect
* -score_nIND       -> score for over-represented variants
* -scoreeQTL        -> score for variants associated with eQTLs
* -scoreG           -> score for variants associated with disease related genes
* -scoreT           -> score for variants associated with TFBS
* -scoreM           -> score for variants at miRNA binding sites
* -scoreR           -> score for variants associated with regulatory elements
* -scoreSP          -> score for variants predicted to disrupt splice sites
* -scoreGW          -> score for variants implicated in relevant phenotypic traits according to a GWAS study

Each parameter configures the minimum and maximum values for different components of the score. Please refer to Chiara et al 2020 and to the online manual for a more extended description. Minimum and maximum values can be specified according to the following syntax: *-parameter <minScore:maxScore>*
The script also perform minimum error checks.

The output of the VINYL optimizer tool consists in a large table which ricapitulates all the values (weigths) used for the calculation of the score components, and (last 4 columns) a p-value for the enrichment in likely pathogenic variants in the affected individuals,the number of total variants and the number of likely pathogenic variants identified in the population of affected individuals and in the controls, respectively. The output of the optimizer is already sorted (in descending order, by p-value), so the *optimal* combination of weigth values of weights combination, is always reported at top.


### Execution of the score_complete_alt_M.pl script for the calculation of pathogenicity scores.

This Perl script accepts the same parameter as the optimizer (see above) with the notable exception that only 1 input file is required. This needs to be a vcf file annotated *by Annovar*, and is specified by the -*ifile* parameter.
Another difference with the optimizer is that this script produces 3 files as its main output. These are:

1. a tabular file with VINYL scores (-ofile)
2. a vcf file with VINYL scores (-ovcfile)
3. a tabular file with the values of all the components of the score for every genetic variant (-o summary).

If no names are specified the default values of *final_res.csv*, *final_res.vcf* and *detailed_final_res.csv* are used.

As stated above, all the other parameters accepted by this program are the same as the parameters accepted by optimizer_genetic.pl. Since however this script performs only the scoring and not the optimization, all the parameters that specify the weights of the various components of the score, *do not accept ranges but need to be specified by using  a single value*. This value needs to be derived from the output of the vinyl optimizer. (see above, and online manual).
A list of the parameters follows:

### Parameters for the configuration of VINYL include: 
  
* -disease  ->     description of the pathological condition. Multiple keywords can be separated by #
* -similarD ->     name of the "sfile" (see configuration files)
* -lgenes   ->     name of the "lgenes" (see configuration files)
* -leQTL    ->     name of the "eqtl" (see configuration files)
* -keywords ->     name of the "kfile" (see configuation files)
* -effects  ->     name of the "efile" (see configuation files)
* -AF       ->     allele frequency cut-off for rare variants, should reflect the prevalence of the disease
* -nind     ->     cut off for the over-representation score (see Chiara et al 2020 and the online manual)
* -AD       ->     is the disease autosomic dominant T/F
* -XL       ->     is the disease autosomic x-linked T/F

### Parameters for the configuration of score values include:
  
* -disease_clinvar  -> score for genetic variants implicated in the pathological condition according to clinval
* -score_AF         -> score for rare variants
* -score_functional -> score for variants with a predicted deleterious effect
* -score_NS         -> score for ns variants with a  predicted disruptive effect
* -score_nIND       -> score for over-represented variants
* -scoreeQTL        -> score for variants associated with eQTLs
* -scoreG           -> score for variants associated with disease related genes
* -scoreT           -> score for variants associated with TFBS
* -scoreM           -> score for variants at miRNA binding sites
* -scoreR           -> score for variants associated with regulatory elements
* -scoreSP          -> score for variants predicted to disrupt splice sites
* -scoreGW          -> score for variants implicated in relevant phenotypic traits according to a GWAS study

Each parameter configures the weight for different components of the score. In this case *exact values and not ranges* need to be specified. Please refer to Chiara et al 2020 and to the online manual for a more extended description. 
Values can be specified according to the following syntax: *-parameter <value>*
The script also perform minimum error checks.

This script need to be *executed twice: one time on the VCF of the control population, and then on the vcf of the affected individuals*. It is crucial to use the same parameters for both files.

### Survival analysis and identification of the optimal cut-off value
Once you have executed the optimizer_genetic.pl script, and computed VINYL scores on both the vcf files of the affected and control populations, using to the optimal score weigths as derived by the optimizer, you can use the survival_M.R utility to infer the optimal cut-off scores.
This has a very simple syntax:

`Rscript --vanilla survival_M.R affected control output`

where

* *affected:* tabular file with VINYL scores for the affected individuals. This is obtained by *running score_complete_alt_M.pl* on the vcf file of the affected individuals
* *control:* equivalent file but for the control population
* *output:* name of the output file

The output file consists in a *simple table*, where for every cut-off value
* (*column 1*) you obtain the number of variants with a score above that cut-off in the "affected" population 
* (*column 2*), the equivalent number for the control population 
* (*column 3*), *the p-value* according to a Fisher test for the over-representation of "surviving or high scoring variants" in the population of affected individuals 
* (column4) and the associated fold change (i.e the relative enrichment of high scoring variants-if any- in the cohort of affected individuals). 

*Ideally the optimal cut-off value is the value that maximizes the fold change and minimizes the Fisher-test p-value.* Anyway any cut-off value associated with a relatively low (5 in 1000 for example) number of high scoring variants in the control population (these should be your false positives) and a relatively high (150 in 1000 for example) number of such variants in the affected population is a good choice.

At this point you have successfully executed the VINYL workflow. See the PCA and boxplot directory for the execution of additional analyses

Feel free to contact me (matteo.chiara@unimi.it) in case of doubts of problems with VINYL

Thanks for using VINYL!!!

Matteo & the VINYL development team
