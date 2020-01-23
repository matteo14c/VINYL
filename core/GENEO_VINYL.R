#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
file1=args[1]
file2=args[2]
config=args[3]
minsV=as.vector(as.integer(unlist(strsplit(args[4], split=" "))))
maxV=as.vector(as.integer(unlist(strsplit(args[5], split=" "))))
ofile=args[6]

header=c("disease_clinvar","score_AF","score_functional","score_NS","score_nIND","scoreeQTL","scoreG","scoreT","scoreM","scoreR","scoreSP","scoreGW","survP","totP","survA","totA","p-value","ratio","score");

cat(paste(header,collapse="\t"),"\n",file=ofile,append=T);
evalVINYL=function(x)
{

        scoreN=c("-disease_clinvar","-score_AF","-score_functional",
		 "-score_NS","-score_nIND","-scoreeQTL",
                 "-scoreG","-scoreT","-scoreM",
		 "-scoreR","-scoreSP","-scoreGW")
	
	params=unlist(paste(scoreN,x,sep=" ",collapse=" "))
	onameprefix=as.integer(runif(1)*10000000)#paste(x,collapse="_");
        oname_files1=unlist(paste(c("-ofile","-ovcfile","-osummary"),
			    paste(rep(file1,3), rep(onameprefix,3), c("ofile","ovcfile","osummary"),sep="."),sep=" ",collapse=" "))
        oname_files2=unlist(paste(c("-ofile","-ovcfile","-osummary"),
                            paste(rep(file2,3), rep(onameprefix,3), c("ofile","ovcfile","osummary"),sep="."),sep=" ",collapse=" "))

	command1=paste("perl ./score_complete_alt_M.pl -vcf",file1,config,params,oname_files1,sep=" ",collapse=" ")#,oname_files1)#,config)#,params)
        command2=paste("perl ./score_complete_alt_M.pl -vcf",file2,config,params,oname_files2,sep=" ",collapse=" ")#,oname_files2)#,config)#,params)
	Res1=system(command1,intern=FALSE)
	Res2=system(command2,intern=FALSE)
	fileR=paste(file1,onameprefix,"ofile",sep=".",collapse="")
	fileT=paste(file2,onameprefix,"ofile",sep=".",collapse="")

	data_R=read.table(fileR,header=T)
	data_T=read.table(fileT,header=T)
	range= rev(seq(min(data_R$VINYL_score),max(data_R$VINYL_score),0.5))
	m=matrix(ncol=2,nrow=2)
	totR=nrow(data_R)
	totT=nrow(data_T)
	score=0;
	surv1=0;
	surv2=0;
	rat=0;
	pval=1;
	for (r in range)
	{
        	posR=sum(data_R$VINYL_score>=r);
        	posT=sum(data_T$VINYL_score>=r)+1;
        	m[,1]=c(posR,totR);
        	m[,2]=c(posT,totT);

        	F=fisher.test(m,alternative="greater")
        	Fpv=F$p.value
        	Fodds=F$estimate
		localScore=0.5*-log10(Fpv)+0.3*Fodds-0.2*posT #+0.175*posR-0.125*posT
		if (localScore>score)
		{
			
			score=localScore
			pval=Fpv
			rat=Fodds
			surv1=posR
			surv2=posT
		
		}

	}
	Command=system("rm *.ofile *.ovcfile *.osummary",intern=FALSE)
	outV=paste(round(x,digits=2),collapse="\t");
	cat(paste(outV,surv1,totR,surv2,totT,pval,rat,score,"\n",sep="\t"),file=ofile,append=T);
	return(score*-1);
}
library(genalg)

G=rbga(stringMin=minsV,stringMax=maxV,popSize=25,iters=30,evalFunc=evalVINYL)
#cat(summary(G),file=ofile,append=T)	

