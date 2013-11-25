##Finds the distance (in stdevs) of tweet counts in sick months to non-sick months as a form of anomaly detection

library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

users = fetch(dbSendQuery(mydb, 'select user as userID from tweets where sick_month=1 group by userID'))

locations = c()

for ( id in 1:length(users$userID))
{

res = fetch(dbSendQuery(mydb, paste('select count(*) as ct, month_index as month_index, sick_month from tweets where user=',users$userID[id],' group by month_index')))

sub = res[which(is.na(res$sick_month)),]

meanVal = mean(sub$ct)
stdVal = sd(sub$ct)

counter = res[which(res$sick_month == 1),]

locations = c(locations,((counter$ct - meanVal) / stdVal))

}

