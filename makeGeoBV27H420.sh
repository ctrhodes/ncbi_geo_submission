#!/bin/bash

#pathname="/home/chris/fastq/BVH3K27me3/raw"

pathname=( "/home/chris/fastq/BVH3K27me3/raw" "/home/chris/fastq/BVH4/raw" "/home/chris/fastq/BVH4K20me3/raw" )

#select dir
#for i in $(ls -d $pathname/*/)

for d in ${pathname[@]}
do

cd $d

pwd


for i in $(ls -d $d/*/)
do
cd ${i%%/}
echo  ${i%%/}


sample=$(ls | grep -o '.*001.*')
describer=$(ls | grep -o '.*001.*' | cut -d _ -f 1)
flowcell=$(basename ${i%%/})
name=${flowcell}.${describer}

echo "sample is "$sample
echo "describer is "$describer
echo "flow cell is "$flowcell
echo "name is "$name
ls

cat *gz > ${name}.fastq.gz 2> ${name}_stderr.txt

echo combining_done!

gzip -d -c ${name}.fastq.gz | md5sum > ${name}_Sum.txt 2>> ${name}_stderr.txt

echo sum_done!

echo leaving_$(ps -aef | grep -o `pwd`)


cd ../

done


done
