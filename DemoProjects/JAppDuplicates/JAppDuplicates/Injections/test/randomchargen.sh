#!/bin/bash

#使用date 生成随机字符串  
random_char=`date +%s%N | md5sum | head -c 10`

echo "====${random_char}"
  
#使用 /dev/urandom 生成随机字符串  
cat /dev/urandom | head -n 10 | md5sum | head -c 10  

echo "===="

randstr() {
  index=0
  str=""
  for i in {a..z}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in {A..Z}; do arr[index]=$i; index=`expr ${index} + 1`; done
  # for i in {0..9}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in {1..6}; do str="$str${arr[$RANDOM%$index]}"; done
  echo $str
}

echo `randstr`

echo "===="