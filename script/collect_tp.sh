echo $1
dir_name=$1
echo "O0 eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O0 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O0 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "O0 func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O0 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O0 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "O0 call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O0 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O0 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo ""

echo "O2 eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O2 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O2 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "O2 func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O2 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O2 | wc -l`
echo "scale=4; $v1/$v2" | bc

echo "O2 call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O2 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O2 | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""

echo "O3 eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O3 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep O3 | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "O3 func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O3 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep O3 | wc -l`
echo "scale=4; $v1/$v2" | bc

echo "O3 call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O3 | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep O3 | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""

echo "Os eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep Os | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep Os | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "Os func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep Os | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep Os | wc -l`
echo "scale=4; $v1/$v2" | bc

echo "Os call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep Os | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep Os | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""

echo "Ofast eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep Ofast | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | grep Ofast | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "Ofast func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep Ofast | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | grep Ofast | wc -l`
echo "scale=4; $v1/$v2" | bc

echo "Ofast call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep Ofast | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | grep Ofast | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""

echo "Summary eh"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep eh | wc -l`
echo "$v1 / $v2"
echo "scale=4; $v1/$v2" | bc

echo "Summary func"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep func | wc -l`
echo "scale=4; $v1/$v2" | bc

echo "Summary call"
v1=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | rev | cut -d ":" -f1 | rev | awk '{s+=$1} END {print s}'`
v2=`grep "TruePositive" -r $dir_name | grep "Result" | grep call | wc -l`
echo "scale=4; $v1/$v2" | bc

echo ""
