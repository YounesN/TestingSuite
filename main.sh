if [[ ! -d "executable" ]]; then
    echo -e "[ERROR] Cannot find all required executables."
    echo -e "\tMake sure you copy your executables into the \"executable\" folder and then run this program."
    echo -e "\tWe need the following executables:"
    echo -e "\t* GOMC_Serial_GCMC"
    echo -e "\t* GOMC_Serial_NVT"
    echo -e "\t* GOMC_Serial_GEMC"
    exit
fi

if [[ ! -f "executable/GOMC_Serial_GCMC" ]]; then
    echo -e "[ERROR] GOMC_Serial_GCMC is missing."
    exit
fi

if [[ ! -f "executable/GOMC_Serial_NVT" ]]; then
    echo -e "[ERROR] GOMC_Serial_NVT is missing."
    exit
fi

if [[ ! -f "executable/GOMC_Serial_GEMC" ]]; then
    echo -e "[ERROR] GOMC_Serial_GEMC is missing."
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
find -name "in.dat" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

echo -e "Found ${#directories[@]} test cases."
echo -e "Copying binary files..."
for i in "${directories[@]}"
do
    if [[ "$i" =~ "GCMC" ]]; then
	cp executable/GOMC_Serial_GCMC "$i"
    elif [[ "$i" =~ "GEMC" ]]; then
	cp executable/GOMC_Serial_GEMC "$i"
    elif [[ "$i" =~ "NVT" ]]; then
	cp executable/GOMC_Serial_NVT "$i"
    else
	echo -e "[ERROR] Couldn't detect the ensemble type. Please include one in the the name of directory"
	echo -e "\tExample: /input/GCMC/case01/"
	exit
    fi
done
echo "Success!"