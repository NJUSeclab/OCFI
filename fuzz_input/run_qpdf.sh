export LD_PRELOAD=$3:${2}/lib/libqpdf.so.29
mkdir -p ${1}_out
for f in `ls $1`; do
	$2/bin/qpdf ${1}/$f /dev/null 2>&1 | tee ${1}_out/${f}.log
done
