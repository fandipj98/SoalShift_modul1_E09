#!/bin/bash

a=1
while true
do
	if [ -f password$a.txt ]
	then
		a=$((a+1))
	else
		len=${#a}
		len1=$(((12-len)/2))
		len2=$((12-len-len1))
		ran1=$a
		ran2=$(cat /dev/urandom | tr -dc A-Z | head -c "$len1")
		ran3=$(cat /dev/urandom | tr -dc a-z | head -c "$len2")
		echo $ran1$ran2$ran3 > password$a.txt
		break
	fi
done

