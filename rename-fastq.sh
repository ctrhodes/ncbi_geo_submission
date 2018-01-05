#!/bin/bash

#select file
for sample in *fastq.gz
do
describer=$(echo ${sample} | sed 's/filtered_//')
echo $sample
echo $describer

mv ${sample} ${describer}

done
