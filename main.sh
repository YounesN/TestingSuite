if [[ ! -d "executable" ]]; then
    echo -e "[ERROR] Cannot find all required executables."
    echo -e "\tMake sure you copy your executables into the \"executable\" folder and then run this program."
    echo -e "\tWe need the following executables:"
    echo -e "\t* GOMC_CPU_GCMC"
    echo -e "\t* GOMC_CPU_NVT"
    echo -e "\t* GOMC_CPU_GEMC"
    echo -e "\t* GOMC_CPU_NPT"
    echo -e "\t* GOMC_GPU_GCMC"
    echo -e "\t* GOMC_GPU_NVT"
    echo -e "\t* GOMC_GPU_GEMC"
    echo -e "\t* GOMC_GPU_NPT"
    exit
fi

if [[ ! -f "executable/GOMC_CPU_GCMC" ]]; then
    echo -e "[ERROR] GOMC_CPU_GCMC is missing."
    exit
fi

if [[ ! -f "executable/GOMC_CPU_NVT" ]]; then
    echo -e "[ERROR] GOMC_CPU_NVT is missing."
    exit
fi

if [[ ! -f "executable/GOMC_CPU_GEMC" ]]; then
    echo -e "[ERROR] GOMC_CPU_GEMC is missing."
    exit
fi

if [[ ! -f "executable/GOMC_CPU_NPT" ]]; then
    echo -e "[ERROR] GOMC_CPU_NPT is missing."
    exit
fi

if [[ ! -f "executable/GOMC_GPU_GCMC" ]]; then
    echo -e "[ERROR] GOMC_GPU_GCMC is missing."
    exit
fi

if [[ ! -f "executable/GOMC_GPU_NVT" ]]; then
    echo -e "[ERROR] GOMC_GPU_NVT is missing."
    exit
fi

if [[ ! -f "executable/GOMC_GPU_GEMC" ]]; then
    echo -e "[ERROR] GOMC_GPU_GEMC is missing."
    exit
fi

if [[ ! -f "executable/GOMC_GPU_NPT" ]]; then
    echo -e "[ERROR] GOMC_GPU_NPT is missing"
    exit
fi


if [[ ! -d "input" ]]; then
    echo -e "[ERROR] Directory \"input\" does not exists."
    echo -e "\tMake sure you copy your input files into the \"input\" folder (each in separate folder)."
    echo -e "\tExample: \"input/test01\" should contain your files for test case 01."
    echo -e "\tExample: \"input/justanotherfolder\" works as well."
    exit
fi

echo -e "Listing test cases..."
directories=()
find ./input -name "in.conf" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

echo -e "Found ${#directories[@]} test cases."
echo -e "Copying binary files..."
for i in "${directories[@]}"
do
    if [[ "$i" =~ "GCMC" ]]; then
	cp executable/GOMC_CPU_GCMC "$i"
	cp executable/GOMC_GPU_GCMC "$i"
    elif [[ "$i" =~ "GEMC" ]]; then
	cp executable/GOMC_CPU_GEMC "$i"
	cp executable/GOMC_GPU_GEMC "$i"
    elif [[ "$i" =~ "NVT" ]]; then
	cp executable/GOMC_CPU_NVT "$i"
	cp executable/GOMC_GPU_NVT "$i"
    elif [[ "$i" =~ "NPT" ]]; then
	cp executable/GOMC_CPU_NPT "$i"
	cp executable/GOMC_GPU_NPT "$i"
    else
	echo -e "[ERROR] Couldn't detect the ensemble type. Please include one in the the name of directory"
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
done

echo -e "Changing Random Seed to Int Seed"
for i in  "${directories[@]}"
do
    sed -i -e 's/RANDOM/INTSEED/g' "$i/in.conf"
    echo "Random_Seed 50" >> "$i/in.conf"
done

echo -e "Listing binary files to run..."
binaries=()
find ./input -name "GOMC_*" -print | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    binaries+=("$REPLY")
done < tmpfile
rm -rf tmpfile
echo -e "Found ${#binaries[@]} executables."
echo -e "Running executables now..."
k=1
for i in "${binaries[@]}"
do
    root=`pwd`
    directory=`dirname $i`
    filename=`basename $i`
    cd $directory
    #echo -e "Changed directory to" `pwd`
    ./$filename in.conf > $k.log
    echo -e "$k/${#binaries[@]} done."
    k=$(($k+1))
    cd $root
    #echo -e "Changed directory to" `pwd`
done

echo "Success!"
