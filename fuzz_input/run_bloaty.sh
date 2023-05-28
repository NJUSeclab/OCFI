export LD_PRELOAD=$3
mkdir -p ${1}_out
for f in `ls $1`; do
	$2/bin/bloaty ${1}/$f 2>&1 | tee ${1}_out/${f}.log
done
