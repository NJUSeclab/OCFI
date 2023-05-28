#!/bin/bash  
#This is the basic example to print a series of numbers from 1 to 10.  

output_dir="$PWD/cpp_output"
#echo ${output_dir}
mkdir -p ${output_dir}
fail_log="${output_dir}/fail.log"
#while [ ! -f ${output_dir}/end ]; do  
depth_res="0"
#total_sz="${output_dir}/size.log"
#total_count="${output_dir}/count.log"
#res=`cat $total_count`
#echo "$total_sz"
CXX=${1}/llvm_ocfi/bin/clang++
T=1
while [ $T -le 10000 ]; do
	let T=T+1
	output_binary="${output_dir}/test_${depth_res}"
	output_name="${output_binary}.cpp"
	output_log="${output_binary}.log"
	now_res=""
	while [ ! -s ${output_log} ]; do
		timeout 100 ${1}/usmith_build/bin/csmith --lang-cpp --cpp11 --probability-configuration 1.txt > ${output_name}
		timeout 100 $CXX ${output_name} -Wno-narrowing -fpermissive -Wwrite-strings -Wno-everything -I${1}/usmith_build/include -o ${output_binary}
		if [ ! -f ${output_binary} ]; then
			continue
		fi
		timeout 10 ${output_binary}  > ${output_log}
		now_res=`grep "Now" ${output_log}`
	done
	now_res=`grep "Now" ${output_log}`
	depth_res=`grep "Depth" ${output_log} | cut -d " " -f 3`
	if [ -z ${depth_res} ]; then
		if [ ! -f ${fail_log} ]; then
			echo "0" > ${fail_log}
		fi
		cat ${fail_log} | python count.py > /tmp/out.log
		cp /tmp/out.log ${fail_log}
		id=`cat ${fail_log}`
		id=${output_dir}/${id}.cpp
		cp ${output_name} ${id}
		rm ${output_binary}
		rm ${output_log}
		rm ${output_name}
		continue
	fi
	depth_out=${output_dir}/${depth_res}.log
	if [ ! -f ${depth_out} ]; then
		echo "0" > ${depth_out}
	fi
	rm ${output_binary}
	rm ${output_log}
	rm ${output_name}
	
	cat ${depth_out} | python count.py > /tmp/out.log
	cp /tmp/out.log ${depth_out}
	echo "-------------------------------"
	grep -r "" ${output_dir}/*.log | sort
done 
grep -r "" ${output_dir}/*.log | sort | rev | cut -d "/" -f 1 | rev > ${1}/usmith_build/bin/res.log
g++ ${1}/usmith_build/bin/collect_usmith.cpp -o ${1}/usmith_build/bin/collect_res
${1}/usmith_build/bin/collect_res ${1}/usmith_build/bin/res.log

