#!/bin/bash
source shrc
mkdir -p $PWD/count_time/x64_ocfi
export OCFI_DIR=$PROJECT_DIR/llvm_ocfi/bin
OPT_LIST=("O0" "O2" "O3" "Of" "Os")
BUILD_LIST=("500" "502" "505" "520" "523" "525" "531" "541" "557" "508" "510" "511" "519" "526" "538" "544")
for OPT in ${OPT_LIST[@]}; do
	config_name="x64_${OPT}_ocfi.cfg"
	for BUILD in ${BUILD_LIST[@]}; do
		output=${PWD}/count_time/x64_ocfi/${BUILD}.log
		(time runcpu --config=${config_name} --tune=base ${BUILD}) 2> $output
		$PROJECT_DIR/script/time_pre $output
	done
done

for BUILD in ${BUILD_LIST[@]}; do
		output=${PWD}/count_time/x64_ocfi/${BUILD}.log_new
		res=`cat $output`
		echo "$BUILD: $res"
done
