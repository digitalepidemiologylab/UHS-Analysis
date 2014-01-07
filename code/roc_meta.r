setEPS();
postscript("meta_roc.eps")

source("oneDimensionAnomalyDetection.r")
roc(sick_times,not_sick_times, col="red",lwd=4, xlab=NA, ylab = NA)
lines(c(0,0,1),c(0,17/35,1),col="blue",lwd=2.5)



mtext("False Positives",1, cex=2,line=3)
mtext("True Positives",2,cex=2,line=2.5)
mtext("A",3,line=-2,cex=4,at=-.16)

library("RWeka")

 read.arff("../data/private/roc_keyword_dm_100_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="green", lwd=4, lty = 1)


 read.arff("../data/roc_keyword_expert_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="orange", lwd=4, lty = 1)

legend(.6,.4, c("Human Classifier", "Anomaly Classifier", "Expert Keyword", "Mined Keyword","Network Classifier", "Baseline"), lty=c(1,1,1,1,1,2), col = c("Blue","Red","Orange","Green","Purple","Black" ), lwd=4)


read.arff("../data/private/network/followers_1000_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="purple", lwd=4, lty = 1)

dev.off()

postscript("meta_roc_final.eps")

plot(c(0,1),c(0,1),lty=2, xlim=c(0,1),ylim=c(0,1),type="l", xlab = NA, ylab = NA)


mtext("False Positives",1, cex=2,line=3)
mtext("True Positives",2,cex=2,line=2.5)
mtext("B",3,line=-2,cex=4,at=-.16)

 read.arff("../data/private/meta/roc_ada.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="blue", lwd=4, lty = 1)

 read.arff("../data/private/meta/roc_bayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="red", lwd=4, lty = 1)

 read.arff("../data/private/meta/roc_j48.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="orange", lwd=4, lty = 1)

 read.arff("../data/private/meta/roc_logitboost.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="green", lwd=4, lty = 1)

 read.arff("../data/private/meta/roc_weighted_vote.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="purple", lwd=4, lty = 1)

 read.arff("../data/private/roc_keyword_dm_100_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="black", lwd=4, lty = 1)



 read.arff("../data/roc_keyword_expert_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

#lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="orange", lwd=4, lty = 1)

legend(.6,.4, c("AdaBoost", "Bayesian", "Decision Tree", "LogitBoost","Weighted Vote", "Mined Keyword"), lty=c(1,1,1,1,1,1), col = c("Blue","Red","Orange","Green","Purple","Black" ), lwd=4)

dev.off()
