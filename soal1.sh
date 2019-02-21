#!/bin/bash

unzip /home/fandipj/nature.zip -d /home/fandipj

a=0

for x in /home/fandipj/nature/*.jpg
do
	`base64 -d $x > /home/fandipj/nature/$a.jpg`
	`xxd -r /home/fandipj/nature/$a.jpg > /home/fandipj/nature/hasil$a.jpg`
	`rm /home/fandipj/nature/$a.jpg $x`
	a=$(($a+1))
done


