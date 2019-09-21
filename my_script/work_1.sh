#!/bin/bash
#1.打印出100以内所有能被7整除的数
#7 14 21... 
for i in {1..100}
do
sum=$(($i%7))
  if [ $sum -eq 0 ];then 
	echo "100以内所有能被7整除的数:$i" 
 fi 
done
