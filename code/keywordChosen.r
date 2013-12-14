Sys.setenv(NOAWT = TRUE)

library(Snowball)
library(epitools)
#test stemmer
l = c("mined","miners","mining","miner","mines")
SnowballStemmer(l)


library(tm)
library("RWeka")
library(RWekajars)


makeWordVector <- function(text){
    return(unique(SnowballStemmer(NGramTokenizer(tolower(text),Weka_control(min=1,max=1)))))
}


nice_p <- function(x)
{
if(x > .0001)
{
return(round(x,digits=4))
}
return(" \\textless 0.0001 ")
}

library(RMySQL)
proc.time() -> startTime
mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

for(keyword in makeWordVector("flu influenza sick cough cold medicine fever")){

tweets = fetch(dbSendQuery(mydb, 'select * from tweets where user in (select userID from users)'),n=-1)
sick_neg = 0
sick_pos = 0

total = 0 

nsick_neg = 0
nsick_pos = 0

for(ct in 1:length(tweets$sick_month))
#for(ct in 1:100)
{
total = total + 1
if(!is.na(tweets[ct,]$sick_month))
{
if(keyword %in% makeWordVector(tweets[ct,]$text))
{
sick_pos = sick_pos + 1
}
else
{
sick_neg = sick_neg + 1
}
}else{
if(keyword %in% makeWordVector(tweets[ct,]$text))
{
nsick_pos = nsick_pos + 1
}
else
{
nsick_neg = nsick_neg + 1
}

}
}
cat(keyword,"&",(sick_pos+nsick_pos),"&",format(round(oddsratio.fisher(c(sick_pos,sick_neg,nsick_pos,nsick_neg))$measure[2,1],digits=2),nsmall=2),"&",nice_p(oddsratio.fisher(c(sick_pos,sick_neg,nsick_pos,nsick_neg))$p.value[2,3]),"\\ \\\\ \\hline \n",sep="",file="keyword_expert_odds.tex",append=TRUE)
cat(keyword,",",sick_pos,",",sick_neg,",",nsick_pos,",",nsick_neg,",",total,"\n")
}

cat("\n\nCompleted in ",(proc.time() - startTime))
