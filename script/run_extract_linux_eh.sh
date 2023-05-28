#!/bin/bash

print_help(){
	echo -e "\t\t -d: required. The directory that contains binary"
	echo -e "\t\t -s: required. The script that extract gt"
	echo -e "\t\t -p: optioal. The output name with prefix(default is gtBlock)"
	exit 0
}

PREFIX="gtBlock"
while getopts "hd:s:p:" arg
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
		p)
			PREFIX=$OPTARG
			;;
	esac
done

if [[ ! -d $DIRECTORY ]]; then
	echo "Please input directory with (-d)!"
	exit -1
fi


for f in `find $DIRECTORY -executable -type f | grep -v "_strip" `; do
	
	dir_name=`dirname $f`
	base_name=`basename $f`

	eh_output=${dir_name}/${base_name}.eh
	if [ ! -f $eh_output ]; then
		echo "===========current file is $f==================="
		readelf --debug-dump=frames ${f} | grep "pc=" | cut -d " " -f 6  | cut -d "." -f 1 | cut -d "=" -f 2 > ${eh_output}
	fi
done

