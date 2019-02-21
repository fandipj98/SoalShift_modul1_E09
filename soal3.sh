#!/bin/bash

a=1
while true
do
	if [ -f password$a.txt ]
	then
		a=$((a+1))
	else
		< /dev/urandom tr -dc A-Za-z0-9 | head -c 12 > password$a.txt
		break
	fi
done

