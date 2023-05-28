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

script=$SCRIPT/script/compare/compareFuncs.py
collect_script=$SCRIPT/script/collect_f1.sh

comp_script=$SCRIPT/script/run_comp_inst.sh
comp_noeh_script=$SCRIPT/script/run_comp_inst_usenix.sh

output_dir=$SCRIPT/result


bash $comp_noeh_script -s $script -d $DIRECTORY -o $output_dir/usenix/GHIDRAN -p BlockGhidra
bash $comp_noeh_script -s $script -d $DIRECTORY -o $output_dir/usenix/ANGRN -p BlockAngr
bash $comp_script -s $script -d $DIRECTORY -o $output_dir/usenix/GHIDRA -p BlockGhidra
bash $comp_script -s $script -d $DIRECTORY -o $output_dir/usenix/ANGR -p BlockAngr

bash $collect_script $output_dir/usenix/GHIDRAN > $output_dir/usenix/GHIDRAN.log
bash $collect_script $output_dir/usenix/GHIDRA > $output_dir/usenix/GHIDRA.log
bash $collect_script $output_dir/usenix/ANGR > $output_dir/usenix/ANGR.log
bash $collect_script $output_dir/usenix/ANGRN > $output_dir/usenix/ANGRN.log

g++ $SCRIPT/script/figure_1.cpp -o $SCRIPT/script/figure1
$SCRIPT/script/figure1 $output_dir


