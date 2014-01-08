setEPS();
postscript("sick_count.eps", width=5*1.5,height=3.5*1.5)
#par(cex.lab=2)
Sys.setenv(NOAWT=1)

library("RWeka")


months = c("August","September","October","November", "December","January","February","March","April","May")

counts = c(0,1,8,34,62,63,37,20,10,1)


barplot(height=counts,names.arg=months,las=3,ylab="Number Sick")



dev.off()
