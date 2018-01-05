#!/bin/bash

for i in *fastq
do

sample=$(basename ${i%%/})
echo "sample is "$sample

md5sum $sample >> sum.txt 2>> ${name}_stderr.txt
#gzip -d -c ${sample} | md5sum > ${name}_Sum.txt 2>> ${name}_stderr.txt

done

