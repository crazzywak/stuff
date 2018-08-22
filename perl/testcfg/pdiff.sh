#!/bin/bash

dir1=$(pwd)/$1
dir2=$(pwd)/$2

num1=$(ls -1 $dir1 | wc -l)
num2=$(ls -1 $dir2 | wc -l)
max=$(( num1 > num2 ? num1 : num2 ))

i=0
j=0
while (( i < max && j < max ))
do

	[ ! -d "$dir1/$i" ] && i=$[$i+1] && continue
	[ ! -d "$dir2/$j" ] && j=$[$j+1] && continue

	if ! cmp "$dir1/$i/0" "$dir2/$j/0" > /dev/null; then
		fs1=$(stat -c%s "$dir1/$i/0")
		fs2=$(stat -c%s "$dir2/$j/0")
		sdiff=$((fs1 - fs2))
		echo "diff $dir1/$i/0 $dir2/$j/0 - $sdiff"
	fi

	i=$[$i+1]
	j=$[$j+1]
done