#!/bin/bash
source shrc
OPT_LIST=("O0" "O2" "O3" "Of" "Os")
BUILD_LIST=("500" "502" "505" "520" "523" "525" "531" "541" "557" "508" "510" "511" "519" "526" "538" "544")
export OCFI_DIR=$PROJECT_DIR/llvm_ocfi/bin
for OPT in ${OPT_LIST[@]}; do
	config_name="aarch64_${OPT}_ocfi.cfg"
	for BUILD in ${BUILD_LIST[@]}; do
		echo "--------------------runcpu --config=${config_name} --tune=base --action=build $BUILD----------------"
		runcpu --config=${config_name} --tune=base --action=build $BUILD
	done
done