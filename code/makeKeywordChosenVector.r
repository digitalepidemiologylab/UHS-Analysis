library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)


Sys.setenv(NOAWT=1)
library(Snowball)

l = c("mined","miners","mining","miner","mines")
SnowballStemmer(l)

library(tm)
library("RWeka")
library(RWekajars)


makeWordVector <- function(text){
    return(unique(SnowballStemmer(NGramTokenizer(tolower(text),Weka_control(min=1,max=1)))))
}

keywords = makeWordVector("flu influenza sick cough cold medicine fever")

text = fetch(dbSendQuery(mydb, "SELECT sick_month, GROUP_CONCAT( TEXT SEPARATOR  ' ' ) AS c FROM tweets INNER JOIN users ON users.userID = tweets.user GROUP BY tweets.user, month_index"),n=-1)

sick = text$sick_month

sick[which(is.na(sick))] = 0
contains = matrix(NA,length(sick),length(keywords))

for(x in 1:length(sick))
{
stemmed = makeWordVector(text[x,]$c)
for(y in 1:length(keywords))
{
contains[x,y] = keywords[y] %in% stemmed
}

}

write.csv(data.frame(contains,sick==1), "../data/expert_keyword_vector.csv")
