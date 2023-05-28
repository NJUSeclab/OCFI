#!/bin/bash
source shrc
LD_PRELOAD="$PROJECT_DIR/hook_cxa_throw/libhook.so"
OPT_LIST=("O0" "O2" "O3" "Of" "Os")
BUILD_LIST=("520" "620" "523" "623" "531" "631" "541" "641" "508" "510" "511" "526")
for OPT in ${OPT_LIST[@]}; do
	config_name="x64_${OPT}_ocfi.cfg"
	for BUILD in ${BUILD_LIST[@]}; do
		echo "--------------------runcpu --config=${config_name} --tune=base --action=build ${BUILD}----------------"
		runcpu --config=${config_name} --tune=base ${BUILD}
	done
done
find $PWD/benchspec/CPU -iname "*.*err" | xargs grep "cxa" > $PWD/exception.res

if [ -f $PWD/final.res ]; then
	rm $PWD/final.res
fi

for BUILD in ${BUILD_LIST[@]}; do
	res=`cat $PWD/exception.res | grep "${BUILD}." | wc -l`
	name=`ls $PWD/benchspec/CPU | grep "${BUILD}."`
	echo "$name: $res" >> $PWD/final.res 
done
cat $PWD/final.res | grep -v ": 0"
