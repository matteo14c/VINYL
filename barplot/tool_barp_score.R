#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
file1=args[1]
scores=as.numeric(args[2])
ofile=args[3]
bdata=read.table(file1,header=T)
bdata[,1:12]=bdata[,1:12]/rowSums(bdata[,1:12])
rownames(bdata)=paste("#rank",c(1:nrow(bdata)))
col=c("#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928")
png(ofile,width=1800,height=800)
par(mar=c(10,10,4,25))
X=barplot(t(bdata[1:scores,1:12]),horiz=T,col=col,legend.text=colnames(bdata)[1:12],args.legend = list(x = "right", bty="n", inset=c(-0.20,0), xpd = TRUE,cex=1.8),space=0.2,cex.axis=1.5,cex.names=2.5,las=2)
dev.off()



