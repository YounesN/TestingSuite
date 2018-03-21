###############################################################################
echo -e "====  Cloning Github Repository"
git clone https://github.com/GOMC-WSU/GOMC
cd GOMC
echo -e "====  Making sure we are on master branch"
git checkout master
echo -e "====  Load CUDA and Intel modules"
module load cuda-8.0/compiler-gpu
module load intel-16/compiler
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
echo -e "====  Copying executables and job scripts to serial"
directories=()
find ./serial -name "in.conf" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

for i in "${directories[@]}"
do
    if [[ "$i" =~ "GCMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GCMC "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_GCMC in.conf \&> out.log#g" serial.inp
	qsub serial.inp
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GEMC "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_GEMC in.conf \&> out.log#g" serial.inp
	qsub serial.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NVT "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_NVT in.conf \&> out.log#g" serial.inp
	qsub serial.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NPT "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_NPT in.conf \&> out.log#g" serial.inp
	qsub serial.inp
	cd $root
    else
	echo -e "[ERROR] Couldn't detect the ensemble type."
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
    sleep 1
done

###############################################################################
echo -e "====  Copying executables and job scripts to openmp"
directories=()
find ./openmp -name "in.conf" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

for i in "${directories[@]}"
do
    if [[ "$i" =~ "GCMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GCMC "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_GCMC +p4 in.conf \&> out.log#g" openmp.inp
	qsub openmp.inp
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GEMC "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_GEMC +p4 in.conf \&> out.log#g" openmp.inp
	qsub openmp.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NVT "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_NVT +p4 in.conf \&> out.log#g" openmp.inp
	qsub openmp.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NPT "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_NPT +p4 in.conf \&> out.log#g" openmp.inp
	qsub openmp.inp
	cd $root
    else
	echo -e "[ERROR] Couldn't detect the ensemble type."
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
    sleep 1
done

###############################################################################
echo -e "====  Copying executables and job scripts to gpu"
directories=()
find ./gpu -name "in.conf" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

for i in "${directories[@]}"
do
    if [[ "$i" =~ "GCMC" ]]; then
	cp ./GOMC/bin/GOMC_GPU_GCMC "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_GCMC in.conf \&> out.log#g" gpu.inp
	qsub gpu.inp
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_GPU_GEMC "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_GEMC in.conf \&> out.log#g" gpu.inp
	qsub gpu.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_GPU_NVT "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_NVT in.conf \&> out.log#g" gpu.inp
	qsub gpu.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_GPU_NPT "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_NPT in.conf \&> out.log#g" gpu.inp
	qsub gpu.inp
	cd $root
    else
	echo -e "[ERROR] Couldn't detect the ensemble type."
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
    sleep 1
done

###############################################################################