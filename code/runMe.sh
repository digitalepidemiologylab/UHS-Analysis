R CMD BATCH makeFigures.r

R CMD BATCH roc_meta.r
R CMD BATCH roc_key_exp.r
R CMD BATCH roc_key_dm.r

mv *.eps ../figs/
