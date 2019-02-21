#!/bin/bash

sh=`date +"%H"`
source1=( {a..z} )
trans1=()
trans1+=( ${source1[@]:(-(26-$sh))} )
trans1+=( ${source1[@]:0:$(($sh))} )
source2=( {A..Z} )
trans2=()
trans2+=( ${source2[@]:(-(26-$sh))} )
trans2+=( ${source2[@]:0:$(($sh))} )
source1+=( ${source2[@]} )
trans1+=( ${trans2[@]} )
NOW=$(date +"%H:%M %d-%m-%Y")
< /var/log/syslog > "$NOW" tr "${source1[*]}" "${trans1[*]}"
