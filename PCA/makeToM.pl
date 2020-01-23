use strict;
use Cwd qw(cwd);

my $valid="perl makeToM.pl <affected> <controls> <output>";
my $exec_path="~/bin";

my $file_aff=shift;
my $file_cont=shift;
my $ofile=shift;

unless (-e $file_aff || -e $file_cont || -e $ofile)
{
	warn("Parameters were not specified correctly\n");
	warn("You need to provide: 1) file with VINYL scores of affected individuals (as obtained from score_complete_altM.pl");
	warn("                     2) file with VINYL scores of controls (as obtained from score_complete_altM.pl");
	warn("                     3) name of the output file");
	warn("This is an example of a valid command:\n\n$valid\n\n");
	die();
}

open(O,">$dir/$ofile.tmp");
my %Final_data=();
my @ids=();

my $ND=populate($file_aff);
my $NH=populate($file_cont);

my $head=join("\t",@ids);
print O "\t$head\n";
foreach my $gene (sort keys %Final_data)
{
        print O "$gene\t";
        foreach (my $j=0;$j<=$#ids;$j++)
        {
                my $individual=$ids[$j];
                my $SCORE=$Final_data{$gene}{$individual} ? $Final_data{$gene}{$individual} : 0;
                if ($j==$#ids)
                {       
                        print O "$SCORE\n";
                }else{  
                        print O "$SCORE\t";
                }               
        }
}

#print "Rscript --vanilla $dir/PCA.R  $ofile $ND $NH $ofile.png\n";
system ("Rscript --vanilla $exec_path/PCA.R $dir/$ofile.tmp $ND $NH $ofile")==0||die($!); 

sub populate
{
	my $file=$_[0];
	open(IN,$file);
	my @P=();
	my $N=0;
	while(<IN>)
	{
		if ($_=~/^#CHROM/)
		{
			my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$info,$format,@Pids)=(split());
			foreach my $P (@Pids)
			{
				push(@ids,$P);
				push(@P,$P);
				$N++;
			}

		}else{
			my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$info,$format,@data)=(split());
			my @infos=split(/\;/,$info);
			my $gene=".";
			my $score=0;
			foreach my $i (@infos)
			{
				if ($i=~/Gene.refGene/)
				{
					$gene=(split(/\=/,$i))[1];
				}elsif ($i=~/VINYL_score/){
					$score=(split(/\=/,$i))[1];
				}
			}
			next if $gene eq ".";
			foreach (my $j=0;$j<=$#data;$j++)
			{
				my $individual=$P[$j];
				my $call=$data[$j];
				next  if $call eq "." || $call eq "0|0";
				if ($Final_data{$gene}{$individual})
				{
					$Final_data{$gene}{$individual}=$score if $score>$Final_data{$gene}{$individual}
				}else{
					$Final_data{$gene}{$individual}=$score;
				}
			
			}	
		}
	}
	return($N);
}
