mkdir -p ${3}
echo "find $1 -executable -type f | grep "\_strip" | grep -v "noeh" | grep $2"
for f in `find $1 -executable -type f | grep "\_strip" | grep -v "noeh" | grep $2`; do
	#echo $f
	sz=`du $f | cut -f 1`
	output_name=$1
	output_name="${output_name//\//@}"
	output_name=${output_name}@${2}
	output_name=`echo $output_name | rev | cut -d @ -f -4 | rev`
	output=${3}/$output_name
	echo "$sz" >> $output
done
