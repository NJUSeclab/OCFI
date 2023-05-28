#echo $1
dir_name=$1
# echo "O0 F1_Score"
v1=`grep "total Functions in ground truth" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "total Functions in compared" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v3=`grep "True positive number" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
echo "scale=4; 2*$v3/($v1+$v2)" | bc

# v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
# v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O0 | wc -l`
# echo "scale=4; $v1/$v2" | bc

# echo ""

# echo "O2 F1_Score"

v1=`grep "total Functions in ground truth" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "total Functions in compared" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v3=`grep "True positive number" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
echo "scale=4; 2*$v3/($v1+$v2)" | bc

# v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
# v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O2 | wc -l`
# echo "scale=4; $v1/$v2" | bc
# echo ""

# echo "O3 F1_Score"

v1=`grep "total Functions in ground truth" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "total Functions in compared" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v3=`grep "True positive number" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
echo "scale=4; 2*$v3/($v1+$v2)" | bc

# v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
# v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O3 | wc -l`
# echo "scale=4; $v1/$v2" | bc
# echo ""

# echo "Os F1_Score"

v1=`grep "total Functions in ground truth" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "total Functions in compared" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v3=`grep "True positive number" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
echo "scale=4; 2*$v3/($v1+$v2)" | bc

# v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
# v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Os | wc -l`
# echo "scale=4; $v1/$v2" | bc
# echo ""

# echo "Ofast F1_Score"

v1=`grep "total Functions in ground truth" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "total Functions in compared" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v3=`grep "True positive number" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
echo "scale=4; 2*$v3/($v1+$v2)" | bc

# v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
# v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Of | wc -l`
# echo "scale=4; $v1/$v2" | bc
# echo ""
