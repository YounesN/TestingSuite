###############################################################################
echo -e "====  Cloning Github Repository"
git clone https://github.com/GOMC-WSU/GOMC
cd GOMC
echo -e "====  Making sure we are on master branch"
git checkout development
echo -e "====  Load CUDA and Intel modules"
moduleload
echo -e "====  Compiling the code"
./metamake.sh
cd ..

###############################################################################
echo -e "====  cloning Github Repository for examples"
git clone https://github.com/GOMC-WSU/GOMC_Examples
cd GOMC_Examples
echo -e "====  Making sure we are on master branch"
git checkout master
cd ..
echo -e "====  Replace Random seed with INTSEED"
directories=()
find ./GOMC_Examples -name "in.conf" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

for i in "${directories[@]}"
do
    sed -i 's/RANDOM/INTSEED/g' $i/in.conf
    printf "\n\nRandom_Seed\t50\n\n" >> $i/in.conf
done
###############################################################################
echo -e "====  Removing .git folder first"
rm -rf ./GOMC_Examples/.git
echo -e "====  Copying examples to serial"
rsync -r GOMC_Examples serial
echo -e "====  Copying examples to openmp"
rsync -r GOMC_Examples openmp
echo -e "====  Copying examples to gpu"
rsync -r GOMC_Examples gpu

###############################################################################
