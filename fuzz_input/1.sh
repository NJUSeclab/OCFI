cnt=0
for f in `find $1 -iname "*.xml"`; do
	let cnt=cnt+1
	cp $f $2/test_${cnt}.xml
done
