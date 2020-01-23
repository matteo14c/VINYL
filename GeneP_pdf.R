args <- commandArgs(trailingOnly = TRUE)
fileR=args[1]
fileT=args[2]
signCoff=args[3]
oname=args[4]
data_R=read.table(fileR,header=T)
data_T=read.table(fileT,header=T)



n=0;
m=min(data_R$VINYL_score)
M=max(data_R$VINYL_score)
Genes=levels(data_R$gene)
GeneP=c()
for (gene in Genes)
{
	F=1
	if (length(data_T[data_T$gene==gene,"VINYL_score"])>=5 && length(data_R[data_R$gene==gene,"VINYL_score"])>=5)
	{ 
		F=round(wilcox.test(data_R[data_R$gene==gene,"VINYL_score"],data_T[data_T$gene==gene,"VINYL_score"],alternative="gr")$p.value,3)
	}
	n=n+1
	GeneP[n]=F
}

Genes=Genes[order(GeneP)]
GeneP=GeneP[order(GeneP)]
n=0
file=paste(oname,"pdf",sep=".")
pdf(file)#,width=1600,height=1600);
par(mfrow=c(3,3),mar=c(3,3,3,2))


for (gene in Genes)
{
	
	n=n+1
	F=GeneP[n]
	boxplot(data_T[data_T$gene==gene,"VINYL_score"],data_R[data_R$gene==gene,"VINYL_score"],col=c("purple","orange"),main=paste(gene,"p-value=" ,F,sep=" "),names=c("Cont","Aff"),ylim=c(m,M))
	abline(a=signCoff,b=0,lwd=2,col="red",lty=3)
	abline(a=0,b=0,lwd=2,col="blue",lty=3)
	#if (n %% 16==0)
	#{
	#	dev.off();
	#	file=paste(oname,n,"png",sep=".")
	#	png(file,width=1600,height=1600,res=160);
	#	par(mfrow=c(4,4),mar=c(2,2,2,1.5))
	#}
}

dev.off();
