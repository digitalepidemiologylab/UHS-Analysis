##Finds the distance (in stdevs) of tweet counts in sick months to non-sick months as a form of anomaly detection

library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

users = fetch(dbSendQuery(mydb, 'select user as userID from tweets where sick_month=1 group by userID'))

sick_times = c()
not_sick_times = c()


for ( id in 1:length(users$userID))
{

res = fetch(dbSendQuery(mydb, paste('select count(*) as ct, month_index as month_index, sick_month from tweets where user=',users$userID[id],' group by month_index')))

sub = res[which(is.na(res$sick_month) & res$ct > 9),]

meanVal = mean(sub$ct)
stdVal = sd(sub$ct)

counter = res[which(res$sick_month == 1),]

sick_times = c(sick_times,((counter$ct - meanVal) / stdVal))

not_sick_times = c(not_sick_times,((sub$ct - meanVal) / stdVal))

}

sick_times = sick_times[which(!is.na(sick_times))]
not_sick_times = not_sick_times[which(!is.na(not_sick_times))]

hist(sick_times,xlim=c(-9,9))
hist(not_sick_times,xlim=c(-9,9))

ks.test(sick_times,not_sick_times)

mean(abs(not_sick_times))
mean(abs(sick_times))

length(which(abs(sick_times)>1)) / length(sick_times)
length(which(abs(not_sick_times)>1)) / length(not_sick_times)
