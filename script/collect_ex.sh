echo $1
dir_name=$1
echo "O0 precision"
v1=`grep "Precision" -r $dir_name |  grep -v truePositive  | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v truePositive | grep -v "Binary file" | grep O0 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc
echo "O0 Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O0 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O0 F1_Score"
v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O0 | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""

echo "O2 precision"
v1=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep O2 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O2 Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O2 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O2 F1_Score"
v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O2 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O2 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo ""

echo "O3 precision"
v1=`grep "Precision" -r $dir_name | grep -v "Binary file" |  grep -v truePositive | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep O3 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O3 Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep O3 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O3 F1_Score"
v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O3 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep O3 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo ""

echo "Os precision"
v1=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep Os | rev | cut -d " " -f1 | rev | grep -v matches | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep Os | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "Os Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep Os | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "Os F1_Score"
v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Os | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Os | wc -l`
echo "scale=4; $v1/$v2" | bc
echo ""

echo "Of precision"
v1=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep Of | rev | cut -d " " -f1 | grep -v matches | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | grep Of | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "Of Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | grep Of | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "Ofast F1_Score"
v1=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Of | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1_Score" -r $dir_name | grep -v "Binary file" | grep Of | wc -l`
echo "scale=4; $v1/$v2" | bc
echo ""

echo "sum precision"
v1=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Precision" -r $dir_name | grep -v "Binary file" | grep -v truePositive | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "sum Recall"
v1=`grep "Recall" -r $dir_name | grep -v "Binary file" | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "Recall" -r $dir_name | grep -v "Binary file" | wc -l`
echo "scale=4; $v1/$v2" | bc
echo "O F1_Score"
v1=`grep "F1 Score" -r $dir_name | grep -v "Binary file" | grep O0 | rev | cut -d " " -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "F1 Score" -r $dir_name | grep -v "Binary file" | grep O0 | wc -l`
echo "scale=4; $v1/$v2" | bc
echo ""
