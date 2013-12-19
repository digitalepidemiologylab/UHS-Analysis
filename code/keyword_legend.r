setEPS()

postscript("keyword_legend.eps",width=1264/150,height=52/150)




colors = c("red","blue","green","orange","purple")


labels = c("J48","Logistic","Naive Bayes","Random Forest","SVM")

par(mar=c(0.0,0,0,0))

plot(1, type="n", axes=F, xlab="", ylab="",xlim=c(0,12),ylim=c(-0.25,2))

text(2*(1:5),y=-.1,labels=labels,adj=c(.5,0))

rect(2*(1:5)-.9,1,2*(1:5)+.9,2,col=colors)

dev.off()
