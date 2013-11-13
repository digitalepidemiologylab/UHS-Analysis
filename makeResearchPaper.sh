mkdir tables
mkdir figs

cd code
bash runMe.sh
cd ..

if [ ! -f tables/keyword_expert_odds.tex ];
then
echo "Rebuilding keyword tables, this may take some time"
touch tables/keyword_expert_odds.tex
cd tables
R CMD BATCH ../code/keywordChosen.r
cd ..    
fi


latex --output-format=pdf Bodnar_www2014
latex --output-format=pdf Bodnar_www2014

BibTex Bodnar_www2014

latex --output-format=pdf Bodnar_www2014
latex --output-format=pdf Bodnar_www2014
