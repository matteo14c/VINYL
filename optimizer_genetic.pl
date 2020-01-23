#!/usr/bin/perl -w
use Cwd;
use strict;
my $valid_command="perl optimizer.pl -fileR <affected.vcf> -fileC <control.vcf> -leQTL <qfile> -similarD <sfile> -disease <disease_terms> -lgenes <lgenes> -nind <nind> -AF <af> -score_AF <min:max> -score_functional <min:max> -score_NS <min:max> -score_nIND <min:max> -scoreeQTL <min:max> -scoreG <min:max> -scoreT <min:max> -scoreM <min:max> -scoreR <min:max> -scoreSP <min:max> -scoreGW <min:max> -AD <AD> -XL <T/F>  -ofile <ofile>";

my %arguments=
(
"fileR"=>"",		    #file: vcf file of affected individuals
"fileC"=>"",		    #file: vcf file of unaffected individuals
"ofile"=>"",		    #name: name of the output files
"AD"=>"T",
"XL"=>"F",		    #
"disease_clinvar"=>[1,10],   #numeric mandadory, multiple values
"score_AF"=>[1,10],          #numeric mandatory, multiple values
"score_functional"=>[1,10],  #numeric mandatory, multiple values
"score_NS"=>[1,10],          #numeric mandatory, multiple values
"score_nIND"=>[1,10],        #numeric mandatory, multiple values
"scoreeQTL"=>[1,10],         #numeric mandatory, multiple values
"scoreG"=>[1,10],            #numeric  mandatory, multiple values
"scoreT"=>[1,10],
"scoreM"=>[1,10],
"scoreR"=>[1,10],
"scoreSP"=>[1,10],
"scoreGW"=>[1,10],
"disease"=>"",          #name   optional
"similarD"=>"",         #file optional
"lgenes"=>"",           #file optional
"leQTL"=>"",       #file   mandatory, but default value
"keywords"=>"",    #file   mandatory, but default value
"effects"=>"",     #file   mandatory, but default value
"nind"=>5,
"AF"=>0.0001
);

unless ($arguments{"fileR"})
{
	
	die("The input vcf file of unaffected individuals was not provided provided.This is a mandatory file.\n\nSee here: $valid_command\n\nFor an example of a valid command\n");
}

unless ($arguments{"fileC"})
{

        die("The input vcf file for the control cohort was not provided provided.This is a mandatory file.\n\nSee here: $valid_command\n\nFor an example of a valid command\n");
}

unless ($arguments{"ofile"})
{

        die("Name of the output file not specified. This is mandatory.\n\nSee here: $valid_command\n\nFor an example of a valid command\n");
}



my @arguments=@ARGV;
for (my $i=0;$i<=$#ARGV;$i+=2)
{
        my $act=$ARGV[$i];
        $act=~s/-//g;
        my $val=$ARGV[$i+1];
        if (exists $arguments{$act})
        {
		unless ($val=~/\:/)
		{
                	$arguments{$act}=$val;
		}else{
			my ($s,$e)=(split(/\:/,$val));
			$arguments{$act}=[$s,$e];
		}
        }else{
                warn("$act: unknown argument\n");
                my @valid=keys %arguments;
                warn("Valid arguments are @valid\n\n");
		warn("Here an example of a valid command: $valid_command\n\n");
                die("All those moments will be lost in time, like tears in rain.\n Time to die!\n");
        }
        #print "$act $val\n";
}

my %compose_ARG=
(
        "disease"=>1,          #name   optional
        "similarD"=>1,         #file optional
        "lgenes"=>1,           #file optional
        "leQTL"=>1,       #file   mandatory, but default value
        "keywords"=>1,    #file   mandatory, but default value
        "effects"=>1,     #file
	"AF"=>1,
	"nind"=>1,
	"AD"=>1,
	"XL"=>1,
);

my $dir=getcwd();
my $add_string=" ";

foreach my $a (keys %compose_ARG)
{
	$add_string.="-$a $arguments{$a} " if $arguments{$a} ne "";
}


my @DC=@{$arguments{"disease_clinvar"}};#=>[2..8],   #numeric mandadory, but default value
my @AF=@{$arguments{"score_AF"}};       #numeric mandatory, but default value
my @FUN=@{$arguments{"score_functional"}};#=>[2..8],  #numeric mandatory, but default value
my @NS=@{$arguments{"score_NS"}};#=>[2..8],          #numeric mandatory, but default value
my @NI=@{$arguments{"score_nIND"}};#=>[2..8],        #numeric mandatory, but default value
my @Q=@{$arguments{"scoreeQTL"}};        #numeric mandatory, but default value
my @G=@{$arguments{"scoreG"}};	#=>[1..3],        #numeric  mandatory, but default value
my @T=@{$arguments{"scoreT"}};
my @M=@{$arguments{"scoreM"}};
my @R=@{$arguments{"scoreR"}};
my @SP=@{$arguments{"scoreSP"}};
my @GW=@{$arguments{"scoreGW"}};

my $Rfile=$arguments{"fileR"};
my $Cfile=$arguments{"fileC"};
my $Ofile=$arguments{"ofile"};

my $minVals="$DC[0] $AF[0] $FUN[0] $NS[0] $NI[0] $Q[0] $G[0] $T[0] $M[0] $R[0] $SP[0] $GW[0]";
my $maxVals="$DC[1] $AF[1] $FUN[1] $NS[1] $NI[1] $Q[1] $G[1] $T[1] $M[1] $R[1] $SP[1] $GW[1]";

system("Rscript --vanilla $dir/GENEO_VINYL.R $Rfile $Cfile \"$add_string\" \"$minVals\" \"$maxVals\" $Ofile.tmp")==0||die("no optimization");

system("(head -n 1 $Ofile.tmp && tail -n +1 $Ofile.tmp | sort -nk 19 -r) > $Ofile")==0||die("no sort");
 
