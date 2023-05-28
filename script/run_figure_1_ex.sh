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

if [[ ! -s $DIRECTORY ]]; then
	echo "Please input project directory with (-s)!"
	exit -1
fi

script=$SCRIPT/script/compare/compareFuncsBySym.py

output_dir=$SCRIPT/result/GHIDRA_NOEH/x64
mkdir -p $output_dir

for f in `find $DIRECTORY/x64_executables -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	
    	strip_dir_name=${dir_name}_noeh_strip
    	
	cmp_file=${strip_dir_name}/BlockGhidra_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done

output_dir=$SCRIPT/result/GHIDRA_NOEH/aarch64
mkdir -p $output_dir

for f in `find $DIRECTORY/aarch64_executables -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	
    	strip_dir_name=${dir_name}_noeh_strip
    	
	cmp_file=${strip_dir_name}/BlockGhidra_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done

output_dir=$SCRIPT/result/GHIDRA_C/x64
mkdir -p $output_dir

for f in `find $DIRECTORY/x64_executables -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	
    	strip_dir_name=${dir_name}_strip
    	
	cmp_file=${strip_dir_name}/BlockGhidra_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done

output_dir=$SCRIPT/result/GHIDRA_C/aarch64
mkdir -p $output_dir

for f in `find $DIRECTORY/aarch64_executables -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	
    	strip_dir_name=${dir_name}_strip
    	
	cmp_file=${strip_dir_name}/BlockGhidra_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done

output_dir=$SCRIPT/result/ANGR_NOEH/x64
mkdir -p $output_dir

for f in `find $DIRECTORY/x64_executables -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	strip_dir_name=${dir_name}_strip

    	cmp_file=${strip_dir_name}/BlockAngrNoeh_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done


output_dir=$SCRIPT/result/ANGR_C
mkdir -p $output_dir

for f in `find $DIRECTORY -executable -type f | grep c_unchanged | grep -v "_strip" `; do
	echo "===========current file is $f==================="
	base_name=`basename $f`
    	dir_name=`dirname $f`
    	strip_dir_name=${dir_name}_strip

    	cmp_file=${strip_dir_name}/BlockAngr_${base_name}.strip.pb
    	output_name=`realpath $f`
    	output_name="${output_name//\//@}"
	output_name=${output_dir}/${output_name}
	
	if [ -f $output_name ]; then
        	echo "skip"
	        continue
    	fi
    	if [ ! -f $cmp_file ]; then
    		echo "[Warning] $f no comparefile!"
		continue
    	fi 
    	python3 $script -c $cmp_file -b $f 2>&1 | tee $output_name
done

