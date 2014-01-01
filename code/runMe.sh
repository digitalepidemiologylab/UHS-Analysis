R CMD BATCH makeFigures.r &

R CMD BATCH roc_meta.r &
R CMD BATCH roc_key_exp.r &
R CMD BATCH roc_key_dm.r &

R CMD BATCH keyword_legend.r &

R CMD BATCH roc_friend.r &
R CMD BATCH roc_followers.r &

wait

mv *.eps ../figs/
