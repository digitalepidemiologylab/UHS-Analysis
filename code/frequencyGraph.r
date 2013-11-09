#install.packages("RMySQL")
library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

users = fetch(dbSendQuery(mydb, 'select * from usersOne'))

setEPS();
postscript("allFrequencies.eps")

plot(NA,xlim=c(-6,6),ylim=c(0,1))

#find average frequency
total = (1:50)*0
found = (1:50)*0


#for anova
type = c()
instances = c()

#for paired
beforePair = c()
atPair = c()
afterPair = c()

for ( id in 1:length(users$id))
{
res = fetch(dbSendQuery(mydb, paste('select count(*) as ct, month_index -',users$month_index[id],'as month_index from tweets where user=',users$userID[id],' group by month_index')))
res$ct_old = res$ct
res$ct = (res$ct - min(res$ct))/(max(res$ct) - min(res$ct))
total[res$month_index+25] = total[res$month_index+25] + res$ct
lines(res$month_index, res$ct,col=rgb(0,0,0))
found[res$month_index+25] = found[res$month_index+25]+1

instances = c(instances, res$ct[which(res$month_index > -4  & res$month_index < 0)])

if(length(which(res$month_index > -4  & res$month_index < 0)) > 0){
for(tmp in 1:length(which(res$month_index > -4  & res$month_index < 0)))
{
	type=c(type,"before")
}}

instances = c(instances, res$ct[which(res$month_index > -1  & res$month_index < 1)])

if(length(which(res$month_index > -1  & res$month_index < 1)) > 0){
for(tmp in 1:length(which(res$month_index > -1  & res$month_index < 1)))
{
        type=c(type,"at")
}}

instances = c(instances, res$ct[which(res$month_index > 0  & res$month_index < 4)])

if(length(which(res$month_index > 0  & res$month_index < 4)) > 0){
for(tmp in 1:length(which(res$month_index > 0  & res$month_index < 4)))
{
        type=c(type,"after")
}}

if(length(which(res$month_index > 0  & res$month_index < 4)) > 0 & length(which(res$month_index > -1  & res$month_index < 1)) > 0 & length(which(res$month_index > -4  & res$month_index < 0)) > 0)
{
beforePair = c(beforePair,mean(res$ct_old[which(res$month_index > -4  & res$month_index < 0)]))

atPair = c(atPair, res$ct_old[which(res$month_index == 0)])

afterPair = c(afterPair ,mean(res$ct_old[which(res$month_index > 0  & res$month_index < 4)]))


}

}

dev.off()
postscript("meanFrequencies.eps")
plot(-3:3,total[22:28]/found[22:28], ylab = "Mean Tweeting Rate",xlab="Months to From Illness")

lines(c(-3,-.5), c(mean(total[22:24]/found[22:24]),mean(total[22:24]/found[22:24])),lty=3)

lines(c(.5,3), c(mean(total[26:28]/found[26:28]),mean(total[26:28]/found[26:28])),lty=3)

dev.off()
