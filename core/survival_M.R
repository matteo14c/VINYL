#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
fileR=args[1]
fileT=args[2]
ofile=args[3]
data_R=read.table(fileR,header=T)
data_T=read.table(fileT,header=T)

#P=wilcox.test(data_R$Score,data_T$Score,alternative="gr")$p.value
range= rev(seq(min(data_R$VINYL_score),max(data_R$VINYL_score),0.25))
header=paste("Cut-off","PosD","PosH","FisherPV","OR",sep="\t");
cat(header,file=ofile,sep="\n",append=T)

m=matrix(ncol=2,nrow=2)
totR=nrow(data_R)
totT=nrow(data_T)
for (r in range)
{
	posR=sum(data_R$VINYL_score>=r);
	posT=sum(data_T$VINYL_score>=r);
	m[,1]=c(posR,totR);
	m[,2]=c(posT,totT);
	
	F=fisher.test(m,alternative="greater")
	Fpv=F$p.value
	Fodds=F$estimate

	string=paste(r,posR,posT,Fpv,Fodds,sep="\t")
	cat(string,file=ofile,sep="\n",append=T)
}
