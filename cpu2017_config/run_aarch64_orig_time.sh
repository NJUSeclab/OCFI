#!/bin/bash
source shrc
mkdir -p $PWD/count_time/aarch64_orig
export ORIG_DIR=$PROJECT_DIR/llvm_orig/bin
OPT_LIST=("O0" "O2" "O3" "Of" "Os")
BUILD_LIST=("500" "502" "505" "520" "523" "525" "531" "541" "557" "508" "510" "511" "519" "526" "538" "544")
for OPT in ${OPT_LIST[@]}; do
	config_name="aarch64_${OPT}_orig.cfg"
	for BUILD in ${BUILD_LIST[@]}; do
		output=${PWD}/count_time/aarch64_orig/${BUILD}.log
		(time runcpu --config=${config_name} --tune=base ${BUILD}) 2> $output
		$PROJECT_DIR/script/time_pre $output
	done
done

for BUILD in ${BUILD_LIST[@]}; do
		output=${PWD}/count_time/aarch64_orig/${BUILD}.log_new
		res=`cat $output`
		echo "$BUILD: $res"
done