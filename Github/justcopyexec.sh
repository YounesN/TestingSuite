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
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GEMC "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_GEMC in.conf \&> out.log#g" serial.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NVT "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_NVT in.conf \&> out.log#g" serial.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NPT "$i"
	cp ./job_scripts/serial.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" serial.inp
	sed -i "s#COMMAND#./GOMC_CPU_NPT in.conf \&> out.log#g" serial.inp
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
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_CPU_GEMC "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_GEMC +p4 in.conf \&> out.log#g" openmp.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NVT "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_NVT +p4 in.conf \&> out.log#g" openmp.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_CPU_NPT "$i"
	cp ./job_scripts/openmp.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" openmp.inp
	sed -i "s#COMMAND#./GOMC_CPU_NPT +p4 in.conf \&> out.log#g" openmp.inp
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
	cd $root
    elif [[ "$i" =~ "GEMC" ]]; then
	cp ./GOMC/bin/GOMC_GPU_GEMC "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_GEMC in.conf \&> out.log#g" gpu.inp
	cd $root
    elif [[ "$i" =~ "NVT" ]]; then
	cp ./GOMC/bin/GOMC_GPU_NVT "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_NVT in.conf \&> out.log#g" gpu.inp
	cd $root
    elif [[ "$i" =~ "NPT" ]]; then
	cp ./GOMC/bin/GOMC_GPU_NPT "$i"
	cp ./job_scripts/gpu.inp "$i"
	root=`pwd`
	cd $i
	sed -i "s#RUN_DIR#$(pwd)#g" gpu.inp
	sed -i "s#COMMAND#./GOMC_GPU_NPT in.conf \&> out.log#g" gpu.inp
	cd $root
    else
	echo -e "[ERROR] Couldn't detect the ensemble type."
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
    sleep 1
done

###############################################################################
