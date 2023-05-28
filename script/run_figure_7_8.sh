#!/bin/bash

print_help(){
	echo -e "\t\t -d: required. The directory that contains binary"
	echo -e "\t\t -s: required. The directory of the project"
	exit 0
}

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

if [[ ! -s $DIRECTORY ]]; then
	echo "Please input project directory with (-s)!"
	exit -1
fi

check_script=$SCRIPT/script/compare/checkObfuscateFuncsBySym.py
comp_script=$SCRIPT/script/compare/compareFuncsBySym.py

x64_dir=$DIRECTORY/x64_executables/
aarch64_dir=$DIRECTORY/aarch64_executables

output_dir=$SCRIPT/result

script=$SCRIPT/script/run_check_sym.sh
collect_script=$SCRIPT/script/collect.sh

bash $SCRIPT/script/run_extract_linux_eh.sh -d $x64_dir/cpp_changed
bash $SCRIPT/script/run_extract_linux_eh.sh -d $x64_dir/c_changed

bash $SCRIPT/script/run_extract_linux_eh.sh -d $aarch64_dir/cpp_changed
bash $SCRIPT/script/run_extract_linux_eh.sh -d $aarch64_dir/c_changed

#Symbol

bash $script -d $x64_dir/cpp_changed -o $output_dir/Symbol/x64 -s $check_script
bash $script -d $x64_dir/c_changed -o $output_dir/Symbol/x64 -s $check_script

bash $script -d $aarch64_dir/cpp_changed -o $output_dir/Symbol/aarch64 -s $check_script
bash $script -d $aarch64_dir/c_changed -o $output_dir/Symbol/aarch64 -s $check_script

#Collect Symbol

bash $collect_script $output_dir/Symbol/aarch64 > $output_dir/Symbol/aarch64_changed.log
bash $collect_script $output_dir/Symbol/x64 > $output_dir/Symbol/x64_changed.log

script=$SCRIPT/script/run_comp_inst_sym.sh

#Ghidra

bash $script -d $x64_dir/c_changed -o $output_dir/Ghidra/x64/changed -s $comp_script -p BlockGhidra
bash $script -d $x64_dir/cpp_changed -o $output_dir/Ghidra/x64/changed -s $comp_script -p BlockGhidra

bash $script -d $x64_dir/c_unchanged -o $output_dir/Ghidra/x64/unchanged -s $comp_script -p BlockGhidra
bash $script -d $x64_dir/cpp_unchanged -o $output_dir/Ghidra/x64/unchanged -s $comp_script -p BlockGhidra

bash $script -d $aarch64_dir/c_changed -o $output_dir/Ghidra/aarch64/changed -s $comp_script -p BlockGhidra
bash $script -d $aarch64_dir/cpp_changed -o $output_dir/Ghidra/aarch64/changed -s $comp_script -p BlockGhidra

bash $script -d $aarch64_dir/c_unchanged -o $output_dir/Ghidra/aarch64/unchanged -s $comp_script -p BlockGhidra
bash $script -d $aarch64_dir/cpp_unchanged -o $output_dir/Ghidra/aarch64/unchanged -s $comp_script -p BlockGhidra


#Collect Ghidra

bash $collect_script $output_dir/Ghidra/aarch64/changed > $output_dir/Ghidra/aarch64_changed.log
bash $collect_script $output_dir/Ghidra/aarch64/unchanged > $output_dir/Ghidra/aarch64_unchanged.log

bash $collect_script $output_dir/Ghidra/x64/changed > $output_dir/Ghidra/x64_changed.log
bash $collect_script $output_dir/Ghidra/x64/unchanged > $output_dir/Ghidra/x64_unchanged.log

#Angr

bash $script -d $x64_dir/c_changed -o $output_dir/Angr/x64/changed -s $comp_script -p BlockAngr
bash $script -d $x64_dir/cpp_changed -o $output_dir/Angr/x64/changed -s $comp_script -p BlockAngr

bash $script -d $x64_dir/c_unchanged -o $output_dir/Angr/x64/unchanged -s $comp_script -p BlockAngr
bash $script -d $x64_dir/cpp_unchanged -o $output_dir/Angr/x64/unchanged -s $comp_script -p BlockAngr

bash $script -d $aarch64_dir/c_changed -o $output_dir/Angr/aarch64/changed -s $comp_script -p BlockAngr
bash $script -d $aarch64_dir/cpp_changed -o $output_dir/Angr/aarch64/changed -s $comp_script -p BlockAngr

bash $script -d $aarch64_dir/c_unchanged -o $output_dir/Angr/aarch64/unchanged -s $comp_script -p BlockAngr
bash $script -d $aarch64_dir/cpp_unchanged -o $output_dir/Angr/aarch64/unchanged -s $comp_script -p BlockAngr

#Collect Angr

bash $collect_script $output_dir/Angr/aarch64/changed > $output_dir/Angr/aarch64_changed.log
bash $collect_script $output_dir/Angr/aarch64/unchanged > $output_dir/Angr/aarch64_unchanged.log

bash $collect_script $output_dir/Angr/x64/changed > $output_dir/Angr/x64_changed.log
bash $collect_script $output_dir/Angr/x64/unchanged > $output_dir/Angr/x64_unchanged.log

#FETCH

bash $script -d $x64_dir/c_changed -o $output_dir/FETCH/x64/changed -s $comp_script -p BlockFETCH
bash $script -d $x64_dir/cpp_changed -o $output_dir/FETCH/x64/changed -s $comp_script -p BlockFETCH

bash $script -d $x64_dir/c_unchanged -o $output_dir/FETCH/x64/unchanged -s $comp_script -p BlockFETCH
bash $script -d $x64_dir/cpp_unchanged -o $output_dir/FETCH/x64/unchanged -s $comp_script -p BlockFETCH

#Collect FETCH

bash $collect_script $output_dir/FETCH/x64/changed > $output_dir/FETCH/x64_changed.log
bash $collect_script $output_dir/FETCH/x64/unchanged > $output_dir/FETCH/x64_unchanged.log

g++ $SCRIPT/script/figure7_8.cpp -o $SCRIPT/script/figure7_8
$SCRIPT/script/figure7_8 $SCRIPT/result
