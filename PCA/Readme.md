#################################################################################################
        IMPORTANT for this script to work you need to have a copy of the PCA.R R script in you ~/bin directory
Alternatively you can edit the makeToM.pl file, and in particular the $exec_path variable at line 5, to reflect the absolute path of PCA.R                                                                                                                
#################################################################################################

These utilities are used to perform PCA (Principal Component Analysis) of patients and controls based on the VINYL pathogenicity score. To perform the analysis you need to use the makeToM.pl script. PCA.R is an helper script that is invoked by the latter. You do not need to use it directly.

An example of a valid command is something like:

<perl makeToM.pl affected controls output>

where:

affected: is a vcf file with VINYL scores, as obtained from the score_complete_alt_M.pl script

controls: is the equivalent file for the control population

and output: is the name of the output file.

The output will consist in a png file, representing the results of the pca analysis. See Figure 4A of Chiara et al 2020 for an example. This type of analysis could be useful for a better stratification of patients based on profiles of presence/absence of potentially pathogenic variants.
