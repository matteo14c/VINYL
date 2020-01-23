This is a simple script used to compare VINYL pathogenicity score on a gene by gene basis. See Chiara et al 2020 (and figure 3 in particular) for an example of the output of this program.
This is a simple R script. You can execute it using the Rscrip utility, and the following syntax:
<Rscript --vanilla GeneP_pdf.R <affected> <controls> <cut_off_score> <output> >
where:
  <affected> is the tabular output file of the score_complete_altM.pl program, containing vinyl scores for the population of  accected individuals
  <controls> is the equivalent files, but for the control population
  <cut_off_score> is the cut-off value used for the identification of pathogenic variants.
  <output> name of the output file
The output of this program test analysis consists of a panel where, for every gene, the distribution  of VINYL  pathogenicity scores, as observed in the cohort of affected individuals, is  compared to the corresponding distribution in the control population. A Mann Whitney Wilcoxon test is used to identify genes showing a significant increase in pathogenicity score. Only genes showing a significant p-value are reported in the output. To facilitate a rapid comparison, score distributions are represented in the form of  boxplots. Dotted lines are used to indicate the “pathogenicity” cut-off value. 
The output is save in the form of a pdf file.
