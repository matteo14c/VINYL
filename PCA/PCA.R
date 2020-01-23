args <- commandArgs(trailingOnly = TRUE)
fileIn=args[1]
nhealth=args[2]
ndis=args[3]
fileO=args[4]
Final_D=read.table(fileIn,header=T,row.names=1)
PCA=prcomp(t(Final_D))
M=PCA$x
png(fileO,width=1800,height=1800,res=160)
plot(M[,1],M[,2],col=rep(c("orange","purple"),c(nhealth,ndis)),main="PCA of gene scores",xlab="PC1",ylab="PC2",cex.main=2,cex.lab=2,pch=20,cex.axis=1.5,cex=1.5)
legend(min(M[,1]),min(M[,2])*0.8,fill=c("orange","purple"),legend=c("affected","unaffected"),cex=1.5)
dev.off()
