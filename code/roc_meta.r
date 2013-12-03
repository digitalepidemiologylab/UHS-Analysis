setEPS();
postscript("meta_roc.eps")

source("oneDimensionAnomalyDetection.r")
roc(sick_times,not_sick_times, col="red",lwd=2.5, xlab="False Positive Rate", ylab = "True Positive Rate")
lines(c(0,0,1),c(0,17/35,1),col="blue",lwd=2.5)

legend(.6,.4, c("Tweet Classifier", "Keyword Classifier", "Expert Keyword", "Mined Keyword","Network Classifier", "Baseline"), lty=c(1,1,1,1,1,2), col = c("Blue","Red","Orange","Green","Purple","Black" ), lwd=2.5)

dev.off()
