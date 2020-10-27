#Heatmap of VINYL score components

This utility is a simple application that allows a rapid comparison of different types of scores and functional annotations associated with genetic variants scored by VINYL. A heatmap representation is used to provide a detailed breakdown of the different components of the VINYL score that form the final score.
Variants/functional annotation that have a similar profile are clustered. Providing an easy and convenient way to identify variants with similar features/annotations in you dataset. To avoid an excessively large/difficult to read output, a score cut-off threshold is used. Only variants above that score cut-off are considered
Please refer utility/application of this tool is described in Chiara et 2020, but also in the online manual of [VINYL](http://90.147.75.93/galaxy/static/manual/,"Manual").

The tool is very simple, and can be executed from the command line using Rscript. A typical example of a command is as follows:

Rscript --vanilla tool_heat_score.R <input_file> <numberToCompare> <outfile>

As you can see the program accepts 3 main input parameters:

* a input file. This needs necessarily to be the output *table* (not the VCF) that you have obtained by running the VINYL *score_complete_alt_M.pl program*
* a number indicating the score threshold. Only variants above this score will be considered. In general we advise that this should be a value close to the optimal score threshold as derived by the survival analysis tool in VINYL 
* the name of an output file

Once the program is successfully executed, a file called output.png will be written to the same folder from which the program was invoked. An example of this type of output is represented by the heatmap.png file in the current folder.
