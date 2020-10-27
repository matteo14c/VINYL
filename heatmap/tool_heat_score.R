#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
file1=args[1]
cutoff=as.numeric(args[2])
ofile=args[3]
data=read.table(file1,header=T,sep="\t")
rownames(data)=paste(data[,1], data[,2], data[,3], data[,4] ,sep="_")
png(ofile,width=1600,height=1800)
heatmap(as.matrix(data[data$ScoreT>=cutoff,9:21]),scale="row",col=colorRampPalette(c("white","purple","magenta"))(100),mar=c(12,16),cexRow=1.2,cexCol=2.5)
dev.off()


