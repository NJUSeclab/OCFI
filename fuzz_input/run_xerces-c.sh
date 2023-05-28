export LD_PRELOAD=$3:${2}/build/lib/libxerces-c-4.0.so
mkdir -p ${1}_out
for f in `find $2 -iname "*.xml"`; do
	$2/build/bin/EnumVal $f 2>> 1.log
done
