#!/bin/bash

for i in *fastq.gz
do

sample=$(basename ${i%%/})
echo "sample is "$sample

gzip -d -c ${sample} | md5sum >> sum.txt 2>> ${name}_stderr.txt
#gzip -d -c ${sample} | md5sum > ${name}_Sum.txt 2>> ${name}_stderr.txt

done

