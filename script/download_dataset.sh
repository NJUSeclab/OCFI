mkdir -p ${1}/dataset
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.0?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.0
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.1?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.1
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.2?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.2
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.3?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.3
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.4?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.4
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.5?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.5
wget https://zenodo.org/record/7949897/files/issta_testsuite.tar.bz2.6?download=1 -O ${1}/dataset/issta_testsuite.tar.bz2.6
cat ${1}/dataset/issta_testsuite.tar.bz2.* > ${1}/issta_testsuite.tar.bz2
tar -xvf ${1}/issta_testsuite.tar.bz2
wget https://zenodo.org/record/6566082/files/x86_dataset.tar.xz?download=1 -O ${1}/x86_dataset.tar.xz
tar -xvf ${1}/x86_dataset.tar.xz
find ${1}/x86_dataset -iname "*_strip" -type d | xargs rm -r 
find ${1}/x86_dataset -iname "*m32*" -type d | xargs rm -r 
find ${1}/x86_dataset -iname "*.sh" -type f | xargs rm -r
mv ${1}/x86_dataset/linux ${1}
wget https://zenodo.org/record/7949897/files/usenix_testsuite_added.tar.bz2?download=1 -O ${1}/usenix_testsuite_added.tar.bz2
tar -xvf ${1}/usenix_testsuite_added.tar.bz2
cp -r ${1}/x64_linux/* ${1}/linux/
rm -r ${1}/x64_linux
num1=`find ${1}/issta_testsuite -iname "*" | wc -l`
num2=`find ${1}/linux -iname "*" | wc -l`
echo "issta file num: $num1"
echo "x86-sok file num: $num2"
