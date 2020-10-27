# Barplot comparison of VINYL scores

This tool is a simple utility that can be used to compare the importance of the different components of the score in scoring systems derived by *VINYL*
An example of the utility/application of this tool is described in Chiara et 2020, but also in the online manual of [VINYL](http://90.147.75.93/galaxy/static/manual/,"Manual").

The tool is very simple, and can be executed from the command line using Rscript. A typical example of a command is as follows:

`Rscript --vanilla tool_barp_score.R <input_file> <numberToCompare> <outfile>`

As you can see the program accepts 3 main input parameters:
1. a input file. This needs necessarily to be the output table that you have obtained by running the VINYL score optimizer
2. a number indicating the number of best (top x) scoring systems that you want to compare
3. the name of an output file

Once the program is successfully executed, a file called *output.png* will be written to the same folder from which the program was invoked. 
An example of this type of output is represented by the *Barplot.png* file in the current folder.
