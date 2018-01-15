#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: \"$0\" <filename>"
        exit
fi

if [ ! -f $1 ]; then
        echo "$1 file not found."
        echo "Usage: $0 <filename>"
        exit
fi

sum=0
count=0
arq=$1

while read line
do
        num=`echo ${line#* }`
        sum=`expr $sum + $num`
        count=`expr $count + 1`
done < "$arq"

if [ "$count" != 0 ]
then
        avg=`expr $sum / $count`
        printf "Sum= \"$sum\" \n Count= \"$count\"  \n Avg= \"$avg\""
        exit 0
else
        printf "Sum= \"$sum\" \n Count= \"$count\"  \n Avg= undefined"
        exit 0
fi