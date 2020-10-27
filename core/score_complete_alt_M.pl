#!/usr/bin/perl  -w
#use strict;

%arguments=
(
"AD"=>"T",		 #value mandatory, T==TRUE F==FALSE
"XL"=>"F",		 #value mandatory, F==FALSE T==TRUE
"vcf"=>"",		 #file	mandatory, provided at runtime
"disease"=>"",		 #name	optional
"similarD"=>"",          #file optional
"lgenes"=>"",            #file optional
"leQTL"=>"",        	 #file   optional
"keywords"=>"kfile",	 #file	mandatory, but default value
"effects"=>"efile",	 #file	mandatory, but default value
"disease_clinvar"=>8, 	 #numeric mandadory, but default value
"score_AF"=>4, 		 #numeric mandatory, but default value
"score_functional"=>8,   #numeric mandatory, but default value
"score_NS"=>6,		 #numeric mandatory, but default value
"score_nIND"=>8,	 #numeric mandatory, but default value
"AF"=>0.0001,		 #numeric mandatory, but default value
"scoreeQTL"=>1,		 #numeric mandatory, but default value
"nind"=>5,		 #numeric  mandatory, but default value
"scoreG"=>2,		 #numeric  mandatory, but default value
"ifile"=>"", 		 #file optional
"scoreT"=>1,		 #numeric mandatory, but default value
"scoreGW"=>1,		 #numeric mandatory but default value
"scoreM"=>1,		 #numeric mandatory but default value
"scoreR"=>1,		 #numeric mandatory but default value
"scoreSP"=>1,		 #numeric mandatory but default value
#####OUTPUT file#############################################
"ofile"=>"final_res.csv", #file #OUTPUT #tabulare
"ovcfile"=>"final_res.vcf",#,  #file #OUTOUT #vcf
"osummary"=>"detailed_final_res.csv"
);

@arguments=@ARGV;
for ($i=0;$i<=$#ARGV;$i+=2)
{
	$act=$ARGV[$i];
	$act=~s/-//g;
	$val=$ARGV[$i+1];
	if (exists $arguments{$act})
	{
		$arguments{$act}=$val;
	}else{
		warn("$act: unknown argument\n");
		@valid=keys %arguments;
		warn("Valid arguments are @valid\n");
		die("All those moments will be lost in time, like tears in rain.\n Time to die!\n");
	}
}

$ofile_name=$arguments{"ofile"};
open(O,">$ofile_name");
$ovcfile=$arguments{"ovcfile"};
open(OV,">$ovcfile");
$osummary_name=$arguments{"osummary"};
open(OS,">$osummary_name");
print OS "chr\tstart\tref\talt\tNhom\tNhet\tNind\tGene\tScoreG\tScoreCV\tScoreOth\tScoreAF\tScoreEff\tScoreSP\tScoreTF\tScoremir\tScoreREG\tScoreGWAS\tScoreNS\tScoreQTL\tScoreNi\tScoreT\n";

$ifile=$arguments{"ifile"};
if (-e $ifile)
{
	open(IN,$ifile);
	while(<IN>)
	{
		#($G1,$G2)=(split());
		#push (@{$interact{$G1}},$G2);
	}
}


$file=$arguments{"vcf"} ;
die ("input file $file not found!\n") unless -e $file;

$lgenes=$arguments{"lgenes"};
if (-e $lgenes)
{
	open(IN,$lgenes);
	while(<IN>)
	{
		chomp;
		$G=(split())[0];
		$Lgenes{$G}=1;
	}
}


$kfile=$arguments{"keywords"};
die ("keyword file $kfile not found!\n") unless -e $kfile;
open(IN,$kfile);
while(<IN>)
{
	chomp;
	($k,$category)=(split())[0,1];
	$specialKeys{$k}=$category;
	push (@{$annotKeys{$category}},$k);
}

$diseaseO=$arguments{"disease"} ? $arguments{"disease"} : "GinocchioValgoDellaLavandaiaZoppa";
@diseaseO=split(/#/,$diseaseO);

$sfile=$arguments{"similarD"};
if (-e $sfile)
{
	open(IN,$sfile);
	while(<IN>)
	{
		chomp;
		$Sw=lc($_);
		$Sw=~s/\s+//;
		push(@kw,$Sw);
	}
}

$efile=$arguments{"effects"};
die ("effect file $efile not found!\n") unless -e $efile;
open(IN,$efile);
while(<IN>)
{
        chomp;
        $effects{$_}=1;
}

$leQTLfile=$arguments{"leQTL"};
if (-e $leQTLfile)
{	
	open(IN,$leQTLfile);
        while(<IN>)
	{
		chomp();
		$Qlist{$_}=1;
	}
}

$disease_clinvar=$arguments{"disease_clinvar"};
$score_AF=$arguments{"score_AF"};
$score_functional=$arguments{"score_functional"};
$score_NS=$arguments{"score_NS"};
$score_nIND=$arguments{"score_nIND"};
$score_QTL=$arguments{"scoreeQTL"};
$scoreG=$arguments{"scoreG"};
$scoreM=$arguments{"scoreM"};
$scoreT=$arguments{"scoreT"};
$scoreR=$arguments{"scoreR"};
$scoreGW=$arguments{"scoreGW"};
$scoreSP=$arguments{"scoreSP"};

#print O "CHR\tstart\tgene\tref\talt\tAC\tNhom\tNhet\tNind\tGene\tScoreCV\tScoreOth\tScoreAF\tScoreEff\tScoreNS\tScoreQTL\tScoreNi\tScoreT\n";
print O "CHR\tstart\tgene\tref\talt\tAC\t";

foreach $k (sort keys %specialKeys)
{
	print O "$k\t";
}
print O "VINYL_score\n";


open(IN,$file);

#print "$gene_score $disease_HGMD $disease_clinvar $score_functional $score_AF $score_NS $score_eQTL $score_nIND\n";
while(<IN>)
{
	if ($_=~/^#/)
	{
		if ($_=~/^#CHROM/)
		{
			@values=split(/\t/,$_);
			$Npeople=$#values-8;
			open(OUTNYM,">num_ind.txt");
			print OUTNYM "$Npeople\n";
		}
		print OV;
		next;
	}
	chomp();
	$summary_line="";
	@val=(split(/\t/));
	$chr=$val[0];
	$start=$val[1];
	$pstart=$val[2];
	$b1=$val[3];
	$b2=$val[4];
	$qscore=$val[5];
	$pb2=$val[6];
	$gene="na";
	$annot=$val[7];
	$gt=$val[8];
	@samples=@val[9..$#val];
	$Nhom=0;
	$Nhet=0;
	$nind=0;
	$summary_line.="$chr\t$start\t$b1\t$b2\t";
	foreach $s (@samples)
	{
		$h1=0;
		$h2=0;
		$sid=(split(/\:/,$s))[0];
		next if $sid eq ".";
		if ($sid=~/\|/)
		{
			($h1,$h2)=(split(/\|/,$sid))[0,1];
		}elsif($sid=~/\//){
			($h1,$h2)=(split(/\//,$sid))[0,1];
		}
		$nind++ if $h1!=0 || $h2!=0;
		$Nhom++ if $h1==$h2 && ($h1 !=0 && $h2!=0); 
		$Nhet++ if $h1!=$h2 && ($h1!=0 || $h2!=0) ;	
	}
	$summary_line.="$Nhom\t$Nhet\t";
	$samples=(join("\t",@samples));
	@terms=(split(/\;/,$annot));
	$DIS=0;
	#if ($_=~/;AC=(\d+);/ || $_=~/\tAC=(\d+);/)
	#{
	#	$nind=$1;
	#}
	if ($_=~/Gene.refGene=(\w+);/)
	{
		$gene=$1;
	}
	$summary_line.="$nind\t$gene\t";
	next if $nind==0;
	$gene=(split(/\,/,$gene))[0];
	$i=0;
	%keep=();
	$score=0;
	%riserva=(7569521=>1, 32974391=>1, 228557681=>1, 228527758=>1, 228525823=>1, 156106964=>1 );
	$score+=6 if $riserva{$start};
	$G=0;
	if ($Lgenes{$gene})
	{
		$score+=$scoreG;
		$G=$scoreG;
	}
	$summary_line.="$G\t";
	foreach $t (@terms)
        {
                next unless $t;
                if ($t=~/\=/)#for terms with a info field
                {
                        ($keep,$value)=(split(/\=/,$t))[0,1];
                        $value="." unless ($value);
                }else{#for flags
                        $value=$t;
                        $keep=$t;
                }
                $keep{$keep}=$value;
        }
	if ($keep{"CLNSIG"} ne "."){
		$scoreO=0;
        	$scoreC=0;
		$add=0;
		$add=$disease_clinvar  if ($keep{"CLNSIG"} eq "Pathogenic" || $keep{"CLNSIG"} eq "Pathogenic,_other,_risk_factor" || $keep{"CLNSIG"} eq "pathogenic" || $keep{"CLNSIG"} eq "Pathogenic/Likely_pathogenic" );
		$add=$disease_clinvar/2  if ($keep{"CLNSIG"} eq "Likely_pathogenic" || $keep{"CLNSIG"} eq "Conflicting_interpretations_of_pathogenicity" || $keep{"CLNSIG"} eq "likely-pathogenic");
		$add-=$disease_clinvar/4 if ($keep{"CLNSIG"} eq "Likely_benign"	||  $keep{"CLNSIG"} eq "Benign/Likely_benign");
		$add-=$disease_clinvar/2 if ($keep{"CLNSIG"} eq "Benign");
		@diseases=split(/\|/,$keep{"CLNDN"});
                @databases=split(/\|/,$keep{"CLNDISDB"});
                for ($i=0;$i<=$#diseases;$i++)
                {
			$dis=lc $diseases[$i];
			$dat=$databases[$i];
			$MDO=0;
			foreach $disOL (@diseaseO)
			{
				$disOL=lc $disOL;
				if ($dis=~ /$disOL/)
                       		{
                        		if ($dat=~/OMIM/)
                                	{	
						$scoreO=$add;
                                	}else{
						$scoreC=$add;
                                	}
					$MDO=1;
					last;
				}
			}
                        if ($MDO==0)
			{
                        	foreach $kv (@kw)
                                {
					if ($dis=~/$kv/)
					{
						$DIS=1 if $add>0;
						if ($dat=~/OMIM/)
                                        	{
							$scoreO=$add;
                                        	}else{
							$scoreC=$add;
                                        	}
					}
                                 }
                        }
		}
		$score+=$scoreO+$scoreC;
		$summary_line.="$scoreO\t$scoreC\t";
		#duplicate this block for KW annotated 
	}else{
		$summary_line.="0\t0\t";
	}
	@AFkeys=@{$annotKeys{"AF"}};
	$AF=0;
	foreach $AFK (@AFkeys)
	{
		$LOC_af=$keep{$AFK} ? $keep{$AFK} : 0 ;
		$LOC_af=0 if $LOC_af eq ".";
		$AF=$LOC_af if $LOC_af>$AF;
	}
	$AF=$AF/20 if ($chr eq "chr1" && ($start==228557681 || $start==228527758 || $start==228525823));	
	if ($AF<=$arguments{"AF"}) #0,00002
	{
		$score+=$score_AF;
		$summary_line.="$score_AF\t";
	}elsif($AF>$arguments{"AF"} && $AF<=$arguments{"AF"}*4){
		$score+=$score_AF/2;
		$summary_line.=$score_AF/2 ."\t";
	}elsif($AF>$arguments{"AF"}*4 && $AF<=0.01){
		$summary_line.="0\t";
	}elsif($AF>0.01){	#commonSNP
		$score-=$score_AF/2;
		$summary_line.=-$score_AF/2 ."\t";
	}
	
	@EFFkeys=@{$annotKeys{"Effect"}};
	$EFFS=0;
	foreach $EFF (@EFFkeys)
	{
		$effectO=(split(/\;/,$keep{$EFF}))[0];
		$score+=$score_functional if $effects{$effectO};
		$EFFS+=$score_functional if $effects{$effectO};
	}
	$summary_line.="$EFFS\t";

	@SPKeys=@{$annotKeys{"Splice"}};
        $SPs=0;
	foreach $SPk (@SPKeys)
	{
		next if ($keep{$SPk} eq ".");
		if($keep{$SPk}>0.6)
		{
			$score+=$scoreSP/($#SPKeys+1);
			$SPs+=$scoreSP/($#SPKeys+1);
		}
	}
	$summary_line.="$SPs\t";

	$TFscore=0;
	@TFBSkeys=@{$annotKeys{"tfbs"}};
	foreach $T (@TFBSkeys)
	{
		$score+=$scoreT if $keep{$T} ne ".";
		$TFscore+=$scoreT if $keep{$T} ne ".";
	}
	$summary_line.="$TFscore\t";
	
	$mirscore=0;
	@mirkeys=@{$annotKeys{"mirna"}};
        foreach $M (@mirkeys)
        {
                $score+=$scoreM if $keep{$M} ne ".";
        	$mirscore+=$scoreM if $keep{$M} ne ".";
	}
	$summary_line.="$mirscore\t";	

	$REGscore=0;
	@REGkeys=@{$annotKeys{"Reg"}};
        foreach $R (@REGkeys)
        {
                $score+=$scoreR if $keep{$R} ne ".";
		$REGscore+=$scoreR if $keep{$R} ne ".";
        }
	$summary_line.="$REGscore\t";
	
 	$GWscore=0; 
	if ($keep{"GWAS"} ne ".")
	{
		$GW=$keep{"GWAS"};
		$GW=lc($GW);
		@Gs=(split(/\|/,$GW));
		foreach $Gword (@Gs)
		{
			next if $Gword eq " ";
			$Gword=~s/-/ /g;
			foreach $kv (@kw)
                	{
				if ($Gword=~/$kv/)
				{
					$score+=$scoreGW;
					$GWscore+=$scoreGW;
					last;
				}
			}
		}

	}
	$summary_line.="$GWscore\t";

	$NSa=0;
	#print "Exon " . $keep{"ExonicFunc.refGene"}. " $score\n";			#modify here to use kwords in conf file
	if ($keep{"ExonicFunc.refGene"} eq "nonsynonymous_SNV")
	{
		$ND=0;
		@NStools=@{$annotKeys{"NStool"}};
		foreach $t (@NStools)
		{
			$NSscore=$keep{$t};
			next if $NSscore eq ".";
			$NSscore="D" if $t=~/CADD/ && $NSscore>=5;
			$ND++ if $NSscore eq "D";
		}

		if ($ND==$#NStools+1)
		{
			$score+=$score_NS;
			$NSa+=$score_NS;
		}elsif($ND>=($#NStools+1)/2){
			$score+=$score_NS/(($#NStools+1)/2);
			$NSa+=$score_NS/(($#NStools+1)/2);
		}elsif($ND==0){
                        $score+=$score_NS/($#NStools+1); #da commentare. o NS/4
			$NSa+=$score_NS/($#NStools+1);
		}
	}
	$summary_line.="$NSa\t";
	$iQTL=0;
	foreach $QTL  (keys %Qlist)
	{
		next unless $keep{$QTL};
		if ($keep{$QTL} ne ".")
		{
			$score+=$score_QTL; 
			$iQTL+=$score_QTL; #if ($keep{$QTL} ne ".");
		}
		
	}
	$summary_line.="$iQTL\t";
	if ($nind>=$arguments{"nind"} && $AF<=0.01)
	{
		$score+=$score_nIND;
		$summary_line.="$score_nIND\t";
	}elsif($nind>=$arguments{"nind"}/2 && $nind<$arguments{"nind"} && $AF<=0.01){
		$score+=$score_nIND/2;
		$summary_line.=$score_nIND/2 ."\t";
	}else{
		$summary_line.="0\t";
	}
	chomp();
	chop($_);
	$outL="";
	$IS_MAL=0;
	foreach $k (sort keys %specialKeys)
	{
		unless($keep{$k})
		{
			#warn("Malformed $_\n");
			warn("please check $k is missing\n");	
			$IS_MAL=1;
		}
		$outL.="$keep{$k}\t";
	}
	next if $IS_MAL==1;
	$score=$score/2 if $arguments{"AD"} eq "F" && $Nhom==0;
	$score=$score/2 if $arguments{"XL"} eq "T" && $chr ne "chrX";
	$summary_line.="$score\n";
	print O "$chr\t$start\t$gene\t$b1\t$b2\t$nind\t$outL$score\n"; #if $score>=12 || $DIS==1;
	print OV "$chr\t$start\t$pstart\t$b1\t$b2\t$qscore\t$pb2\t$annot;VINYL_score=$score\t$gt\t$samples\n";
	print OS "$summary_line";
}
