#!/bin/bash

print_help(){
	echo -e "\t\t -d: required. The directory that contains binary"
	echo -e "\t\t -s: required. The directory of the project"
	exit 0
}

PREFIX="gtBlock"
while getopts "hd:s:" arg
do
	case $arg in
		h)
			print_help
			;;
		d)
			DIRECTORY=$OPTARG
			;;
		s)
			SCRIPT=$OPTARG
			;;
	esac
done

if [[ ! -d $DIRECTORY ]]; then
	echo "Please input dataset directory with (-d)!"
	exit -1
fi

if [[ ! -d $SCRIPT ]]; then
	echo "Please input project directory with (-s)!"
	exit -1
fi

script=$SCRIPT/script/run_count_truepositive.sh
comp_script=$SCRIPT/script/compare/countTPFrom.py

bash $script -d $DIRECTORY/x64_executables/c_changed -s $comp_script -o $SCRIPT/result/count/angr/x64 -p "BlockAngr"
bash $script -d $DIRECTORY/x64_executables/cpp_changed -s $comp_script -o $SCRIPT/result/count/angr/x64 -p "BlockAngr"
bash $script -d $DIRECTORY/aarch64_executables/c_changed -s $comp_script -o $SCRIPT/result/count/angr/aarch64 -p "BlockAngr"
bash $script -d $DIRECTORY/aarch64_executables/cpp_changed -s $comp_script -o $SCRIPT/result/count/angr/aarch64 -p "BlockAngr"
bash $script -d $DIRECTORY/x64_executables/c_changed -s $comp_script -o $SCRIPT/result/count/ghidra/x64 -p "BlockGhidra"
bash $script -d $DIRECTORY/x64_executables/cpp_changed -s $comp_script -o $SCRIPT/result/count/ghidra/x64 -p "BlockGhidra"
bash $script -d $DIRECTORY/aarch64_executables/c_changed -s $comp_script -o $SCRIPT/result/count/ghidra/aarch64 -p "BlockGhidra"
bash $script -d $DIRECTORY/aarch64_executables/cpp_changed -s $comp_script -o $SCRIPT/result/count/ghidra/aarch64 -p "BlockGhidra"



angr_dir=$SCRIPT/result/count/angr
ghidra_dir=$SCRIPT/result/count/ghidra
v1=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep eh | grep -v "print(" | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep eh | grep -v "print(" | wc -l`
angr_eh_res=`echo "scale=6; $v1/$v2" | bc`


v1=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep func | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep func | wc -l`
angr_func_res=`echo "scale=6; $v1/$v2" | bc`

v1=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep call | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $angr_dir | grep "\[Result" | grep call | wc -l`
angr_call_res=`echo "scale=6; $v1/$v2" | bc`


v1=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep eh | grep -v "print(" | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep eh | grep -v "print(" | wc -l`
ghidra_eh_res=`echo "scale=6; $v1/$v2" | bc`


v1=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep func | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep func | wc -l`
ghidra_func_res=`echo "scale=6; $v1/$v2" | bc`

v1=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep call | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $ghidra_dir | grep "\[Result" | grep call | wc -l`
ghidra_call_res=`echo "scale=6; $v1/$v2" | bc`

echo "         eh_frame   matching    call"
echo "ghidra: $ghidra_eh_res    $ghidra_func_res    $ghidra_call_res"
echo "angr:   $angr_eh_res    $angr_func_res    $angr_call_res"

