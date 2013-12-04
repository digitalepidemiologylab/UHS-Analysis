setEPS();
postscript("key_dm_roc.eps")

Sys.setenv(NOAWT=1)

library("RWeka")

files = c("../data/private/roc_keyword_dm_10_j48.arff","../data/private/roc_keyword_dm_10_logistic.arff","../data/private/roc_keyword_dm_10_naivebayes.arff","../data/private/roc_keyword_dm_10_randomforest.arff","../data/private/roc_keyword_dm_10_smo.arff","../data/private/roc_keyword_dm_100_j48.arff","../data/private/roc_keyword_dm_100_logistic.arff","../data/private/roc_keyword_dm_100_naivebayes.arff","../data/private/roc_keyword_dm_100_randomforest.arff","../data/private/roc_keyword_dm_100_smo.arff","../data/private/roc_keyword_dm_1000_j48.arff","../data/private/roc_keyword_dm_1000_logistic.arff","../data/private/roc_keyword_dm_1000_naivebayes.arff","../data/private/roc_keyword_dm_1000_randomforest.arff","../data/private/roc_keyword_dm_1000_smo.arff")

colors = c("red","blue","green","orange","purple")
colors = c(colors,colors,colors)

linetype = c(1,1,1,1,1,2,2,2,2,2,4,4,4,4,4)

plot(c(0,1),c(0,1),lty=2, xlim=c(0,1),ylim=c(0,1),type="l", xlab = "False Positive", ylab = "True Positive")

for(x in 1:length(files))
{
 read.arff(files[x]) -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col=colors[x], lwd=2, lty = linetype[x])
}

dev.off()
