for f in `find $1 -executable -type f | grep -v "_strip" `; do
	f_name=`basename $f`
	real_path=`dirname $f`
	dir_name="${real_path}_strip"
	if [ ! -d $dir_name ]; then
		mkdir -p $dir_name
	fi
	strip_path="${dir_name}/${f_name}.strip"
	if [ -f $strip_path ]; then
		continue
	fi
	echo $strip_path
	cp $f $strip_path
	strip $strip_path
done
