setEPS();
postscript("meta_roc.eps")

source("oneDimensionAnomalyDetection.r")
roc(sick_times,not_sick_times, col="red",lwd=2.5, xlab="False Positive Rate", ylab = "True Positive Rate")
lines(c(0,0,1),c(0,17/35,1),col="blue",lwd=2.5)


library("RWeka")

 read.arff("../data/private/roc_keyword_dm_100_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="green", lwd=2.5, lty = 1)


 read.arff("../data/roc_keyword_expert_naivebayes.arff") -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col="orange", lwd=2.5, lty = 1)

legend(.6,.4, c("Human Classifier", "Anomaly Classifier", "Expert Keyword", "Mined Keyword","Network Classifier", "Baseline"), lty=c(1,1,1,1,1,2), col = c("Blue","Red","Orange","Green","Purple","Black" ), lwd=2.5)

dev.off()
