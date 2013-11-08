#install.packages("RMySQL")
library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

users = fetch(dbSendQuery(mydb, 'select * from usersOne'))

plot(NA,xlim=c(-6,6),ylim=c(0,1))

total = (1:50)*0
found = (1:50)*0

for ( id in 1:length(users$id))
{
res = fetch(dbSendQuery(mydb, paste('select count(*) as ct, month_index -',users$month_index[id],'as month_index from tweets where user=',users$userID[id],' group by month_index')))

res$ct = (res$ct - min(res$ct))/(max(res$ct) - min(res$ct))
total[res$month_index+25] = total[res$month_index+25] + res$ct
lines(res$month_index, res$ct)
found[res$month_index+25] = found[res$month_index+25]+1
}



plot(-3:3,total[22:28]/found[22:28], ylab = "Mean Tweeting Rate",xlab="Months to From Illness")

lines(c(-3,-.5), c(mean(total[22:24]/found[22:24]),mean(total[22:24]/found[22:24])),lty=3)

lines(c(.5,3), c(mean(total[26:28]/found[26:28]),mean(total[26:28]/found[26:28])),lty=3)
