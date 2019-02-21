#!/bin/bash

a=`awk -F, '{if($7=="2012") arr[$1]=arr[$1]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, 'NR==1 {print $1}'`
echo $a

declare -A b

for x in 1 2 3
do
	b[$x]=`awk -F, -v a="$a" '{if($1==a) arr[$4]=arr[$4]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
done
echo ${b[@]}

declare -A c

for x in 1 2 3
do
	c[$x]=`awk -F, -v a="$a" -v b1="${b[1]}" -v b2="${b[2]}" -v b3="${b[3]}" '{if(($4==b1 || $4==b2 || $4==b3) && $1==a) arr[$6]=arr[$6]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t"," -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
done
echo ${c[@]}
