echo -e "====  Testing the outputs now"
directories=()
find ./serial -name "out.log" -printf '%h\n' | sort -u > tmpfile
while IFS= read -r -d $'\n'; do
    directories+=("$REPLY")
done < tmpfile
rm -rf tmpfile

k=1
for i in "${directories[@]}"
do
    openmp="${i/serial/openmp}"
    gpu="${i/serial/gpu}"
    diffwithopenmp=`diff $i/out.log $openmp/out.log`
    diffwithgpu=`diff $i/out.log $gpu/out.log`
    if [[ $diffwithopenmp = *"MOVE_0"* ]]; then
	echo -e "OpenMP is different:"
	echo -e "You may want to check $i"
	echo -e "I put the diff log in $k.log"
	echo $diffwithopenmp >> $k.log
	k=$(($k+1))
    fi
    if [[ $diffwithgpu = *"MOVE_0"* ]]; then
	echo -e "GPU is different:"
	echo -e "You may want to check $i"
	echo -e "I put the diff log in $k.log"
	echo $diffwithgpu >> $k.log
	k=$(($k+1))
    fi
done