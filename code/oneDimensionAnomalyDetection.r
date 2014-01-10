##Finds the distance (in stdevs) of tweet counts in sick months to non-sick months as a form of anomaly detection

library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

users = fetch(dbSendQuery(mydb, 'select user as userID from tweets where sick_month=1 group by userID'))

sick_times = c()
not_sick_times = c()
id_str = c()
z_score = c()

for ( id in 1:length(users$userID))
{

res = fetch(dbSendQuery(mydb, paste('select count(*) as ct, month_index as month_index, sick_month from tweets where user=',users$userID[id],' group by month_index')))

sub = res[which(is.na(res$sick_month) & res$ct > 9),]
if(length(res$ct) > 0){
meanVal = mean(sub$ct)
stdVal = sd(sub$ct)

counter = res[which(res$sick_month == 1),]

sick_times = c(sick_times,((counter$ct - meanVal) / stdVal))

not_sick_times = c(not_sick_times,((sub$ct - meanVal) / stdVal))

for( mindex in 1:length(res$ct))
{
subsub = res[mindex,]

if(subsub$ct > 9){
z_score = c(z_score,(subsub$ct - meanVal) / stdVal)
}
else
{
z_score = c(z_score,0)
}

id_str = c(id_str, paste(users$userID[id],subsub$month_index[1],sep="_"))

}
}
}

write.csv(data.frame(id_str,z_score),"../data/private/model_predictions/anomaly.csv")

sick_times = sick_times[which(!is.na(sick_times))]
not_sick_times = not_sick_times[which(!is.na(not_sick_times))]

hist(sick_times,xlim=c(-9,9))
hist(not_sick_times,xlim=c(-9,9))

ks.test(sick_times,not_sick_times)

mean(abs(not_sick_times))
mean(abs(sick_times))

length(which(abs(sick_times)>1)) / length(sick_times)
length(which(abs(not_sick_times)>1)) / length(not_sick_times)

#calculates the optimal division (through brute force...)
#fOne = use f1 measure instead of accuracy?
optimal_cut <- function(negative, positive, sensitivity = 1e-3, fOne = FALSE)
{
sequence = seq(0,10,sensitivity)
optimal = -1
optimal_score = -99999999
negative = abs(negative)
positive = abs(positive)
scores = sequence

for(cut in sequence)
{
score = -1
if(fOne)
{
tp = length(which(negative > cut))
fp = length(which(positive > cut))
fn = length(which(negative <= cut))
score = (2*tp)/(2*tp+fn+fp)

if(is.na(score))
{
score = -1
}

}
else
{
score = length(which(negative > cut)) + length(which(positive <= cut)) - length(which(negative <= cut)) - length(which(positive > cut))
}

if(score > optimal_score)
{
optimal_score = score
optimal = cut
}
scores[which(sequence == cut)] = score
}
plot(sequence, scores)
return(optimal)
}


make_confusion <- function(negative, positive, cut = -9999)
{
if(cut < 0)
{
cut = optimal_cut(negative, positive)
}

negative = abs(negative)
positive = abs(positive)

values = matrix(NA,2,2)
values[1,1] = length(which(negative > cut))
values[1,2] = length(which(negative <= cut))

values[2,1] = length(which(positive > cut))
values[2,2] = length(which(positive <= cut))


return(values)
}

eval_confusion <- function(matrix,fOne=FALSE)
{
if(fOne)
{
return((2*matrix[1,1])/(2*matrix[1,1]+matrix[2,1]+matrix[1,2]))
}
return((matrix[1,1]+matrix[2,2])/sum(matrix))
}


leave_one_out <- function(negative, positive, ...)
{
values = matrix(0,2,2)
negative = abs(negative)
positive = abs(positive)
spread = c()
for( ct in 1:length(negative))
{
cut = optimal_cut(negative[-ct],positive,...)
spread = c(spread,cut)
if(negative[ct] > cut)
{
values[1,1] = values[1,1]+1
}
else
{
values[1,2] = values[1,2]+1
}
}

for( ct in 1:length(positive))
{
cut = optimal_cut(negative,positive[-ct],...)
spread = c(spread,cut)
if(positive[ct] > cut)
{
values[2,1] = values[2,1]+1
}
else
{
values[2,2] = values[2,2]+1
}
}
d = NA
d$confusion = values
d$hist = spread
return(d)
}

roc <- function(negative, positive, sensitivity = 1e-3, ...)
{
fp = c()
tp = c()

sequence = seq(0,10,sensitivity)

for(cut in sequence)
{
make_confusion(negative, positive, cut = cut) -> m
fp = c(fp, m[2,1])
tp = c(tp, m[1,1])
}

fp = fp / length(positive)
tp = tp / length(negative)

plot(fp,tp, type = "l", ...)
lines(c(0,1),c(0,1), lty=2)

auc = 0

for(j in 1:(length(tp)-1))
{
if(fp[j]-fp[j+1] != 0)
{
auc = auc + (tp[j]+tp[j+1])/2 * (fp[j]-fp[j+1])
}
}

return(auc)
}

leave_one_out(sick_times,not_sick_times,fOne=TRUE) -> result
#leave_one_out(sick_times,not_sick_times, sensitivity = 1e-5) -> result #for final run


eval_confusion(make_confusion(sick_times,not_sick_times, cut = mean(result$hist)),fOne=TRUE)

make_confusion(sick_times,not_sick_times, cut = mean(result$hist))

