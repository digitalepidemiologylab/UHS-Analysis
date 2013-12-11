setEPS();
postscript("key_exp_roc.eps")


Sys.setenv(NOAWT=1)

library("RWeka")

files = c("../data/roc_keyword_expert_j48.arff","../data/roc_keyword_expert_logistic.arff","../data/roc_keyword_expert_naivebayes.arff","../data/roc_keyword_expert_randomForest.arff","../data/roc_keyword_expert_smo.arff")

colors = c("red","blue","green","orange","purple")


plot(c(0,1),c(0,1),lty=2, xlim=c(0,1),ylim=c(0,1),type="l", xlab = NA, ylab = NA)

mtext("False Positives",1, cex=2,line=3)
mtext("True Positives",2,cex=2,line=2.5)
mtext("A",3,line=-2,cex=4,at=-.15)


for(x in 1:length(files))
{
 read.arff(files[x]) -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col=colors[x], lwd=2)
}

dev.off()
