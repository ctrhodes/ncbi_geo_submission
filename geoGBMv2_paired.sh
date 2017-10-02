#!/bin/bash

#space separated list of dirs
pathname=("/home/chris/geoSubmissions/RNA-Seq/" "/home/chris/geoSubmissions/RNA-Seq/")
echo "dir list is: "${pathname[@]}

tmp=("/home/chris/geoSubmissions/RNA-Seq/tmp")
echo "temp folder is: "$tmp

for d in ${pathname[@]}
do
cd $d
pwd


#only need if recursing through dirs (i.e. Sample_control-1)
for i in $(ls -d $d/*/)
do
cd ${i%%/}
echo  ${i%%/}

folder=$(basename ${i%%/})
echo "folder is "$folder

flowcell=$(ls | grep -E _L[0-9]+?_R[0-9].*fastq.gz | grep -v filtered | sort | sed -n '1p' | cut -d _ -f 1-2)
echo "flow cell is "$flowcell


#Files
files=$(ls | grep -E _L[0-9]+?_R[0-9].*fastq.gz | grep -v filtered | sort)
#echo $files

regex="_L([0-9]+)_"
echo "regex is: "$regex

for f in $files
do
if [[ $f =~ $regex ]]
then
  index=$(echo "${BASH_REMATCH[1]}" | grep -o [^0])
  indexArray[$index]+=$( echo $index\ )
  fileArray[$index]+=$( echo $f\ )
else
  continue
fi
done

lanesUnique=$(echo "${indexArray[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

echo "unique lanes are: "$lanesUnique
echo "pretty print fileArray"
printf '%s\n' "${fileArray[@]}"


for i in $lanesUnique
do
echo $i
for element in ${fileArray[$i]}
do
if echo $element | grep "_R1_"
then
  leftArray[$i]+=$( echo $element\ )
elif echo $element | grep "_R2_"
then
  rightArray[$i]+=$( echo $element\ )
else
  continue
fi
done
done

echo "pretty print leftArray"
printf '%s\n' "${leftArray[@]}"
echo "pretty print rightArray"
printf '%s\n' "${rightArray[@]}"


###
#Business
##
for i in $lanesUnique
do
leftName=${flowcell}_${i}_R1.fastq.gz
rightName=${flowcell}_${i}_R2.fastq.gz
echo $i
echo "left name: "$leftName

cat ${leftArray[$i]} > $tmp/$leftName
echo "right name: "$rightName

cat ${rightArray[$i]} > $tmp/$rightName
done
###
#Done Business
###

unset index
unset indexArray
unset fileArray
unset lanesUnique
unset leftArray
unset rightArray


#end of initial 2 location loops
echo "leaving: "$(ps -aef | grep -o `pwd`)
cd ../
done

done


