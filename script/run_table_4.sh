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


script=$SCRIPT/script/check_size.sh
output_dir=$SCRIPT/count_size
if [ -d $output_dir ]; then
    rm -r $output_dir
fi

bash $SCRIPT/script/extract_strip.sh $DIRECTORY

find $DIRECTORY/x64_executables/c_changed -iname "ld.bfd.strip" | xargs rm 

bash $script $DIRECTORY/x64_executables/c_unchanged O0 $output_dir
bash $script $DIRECTORY/x64_executables/c_unchanged O2 $output_dir
bash $script $DIRECTORY/x64_executables/c_unchanged O3 $output_dir
bash $script $DIRECTORY/x64_executables/c_unchanged Os $output_dir
bash $script $DIRECTORY/x64_executables/c_unchanged Ofast $output_dir

bash $script $DIRECTORY/aarch64_executables/c_unchanged O0 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_unchanged O2 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_unchanged O3 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_unchanged Os $output_dir
bash $script $DIRECTORY/aarch64_executables/c_unchanged Ofast $output_dir

bash $script $DIRECTORY/x64_executables/cpp_unchanged O0 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_unchanged O2 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_unchanged O3 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_unchanged Os $output_dir
bash $script $DIRECTORY/x64_executables/cpp_unchanged Ofast $output_dir


bash $script $DIRECTORY/aarch64_executables/cpp_unchanged O0 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_unchanged O2 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_unchanged O3 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_unchanged Os $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_unchanged Ofast $output_dir

bash $script $DIRECTORY/x64_executables/c_changed O0 $output_dir
bash $script $DIRECTORY/x64_executables/c_changed O2 $output_dir
bash $script $DIRECTORY/x64_executables/c_changed O3 $output_dir
bash $script $DIRECTORY/x64_executables/c_changed Os $output_dir
bash $script $DIRECTORY/x64_executables/c_changed Ofast $output_dir

bash $script $DIRECTORY/aarch64_executables/c_changed O0 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_changed O2 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_changed O3 $output_dir
bash $script $DIRECTORY/aarch64_executables/c_changed Os $output_dir
bash $script $DIRECTORY/aarch64_executables/c_changed Ofast $output_dir

bash $script $DIRECTORY/x64_executables/cpp_changed O0 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_changed O2 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_changed O3 $output_dir
bash $script $DIRECTORY/x64_executables/cpp_changed Os $output_dir
bash $script $DIRECTORY/x64_executables/cpp_changed Ofast $output_dir


bash $script $DIRECTORY/aarch64_executables/cpp_changed O0 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_changed O2 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_changed O3 $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_changed Os $output_dir
bash $script $DIRECTORY/aarch64_executables/cpp_changed Ofast $output_dir

g++ $SCRIPT/script/table_4.cpp -o $SCRIPT/script/table4
$SCRIPT/script/table5 $output_dir


