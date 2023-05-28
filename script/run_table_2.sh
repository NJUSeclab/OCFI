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


input_dir=$SCRIPT/fuzz_input/
OLD_PRELOAD=$LD_PRELOAD

# bloaty
export LD_PRELOAD="$OLD_PRELOAD:$SCRIPT/hook_cxa_throw/libhook.so"
output_dir=$SCRIPT/fuzz_input/bloaty_out
mkdir -p $output_dir

for f in `ls ${input_dir}/bloaty `; do
    $SCRIPT/bloaty/build/bin/bloaty ${input_dir}/bloaty/${f} 2>&1 | tee ${output_dir}/${f}.log
done

bloaty_output=`grep -R "cxa" ${output_dir} | wc -l`

# qpdf
export LD_PRELOAD="$OLD_PRELOAD:$SCRIPT/hook_cxa_throw/libhook.so:$SCRIPT/qpdf-11.0.0/build/lib/libqpdf.so.29"
output_dir=$SCRIPT/fuzz_input/qpdf_out
mkdir -p $output_dir

for f in `ls ${input_dir}/qpdf `; do
    $SCRIPT/qpdf-11.0.0/build/bin/qpdf ${input_dir}/qpdf/${f} /dev/null 2>&1 | tee ${output_dir}/${f}.log
done

qpdf_output=`grep -R "cxa" ${output_dir} | wc -l`

# xerces-c
export LD_PRELOAD="$OLD_PRELOAD:$SCRIPT/hook_cxa_throw/libhook.so:$SCRIPT/xerces-c/build/lib/libxerces-c-4.0.so"
output_dir=$SCRIPT/fuzz_input/xerces-c_out
mkdir -p $output_dir

for f in `ls ${input_dir}/xerces-c `; do
    $SCRIPT/xerces-c/build/bin/EnumVal ${input_dir}/xerces-c/${f} 2>&1 | tee ${output_dir}/${f}.log
done

xerces_output=`grep -R "cxa" ${output_dir} | wc -l`
echo "bloaty: $bloaty_output"
echo "qpdf: $qpdf_output"
echo "xerces-c: $xerces_output"

