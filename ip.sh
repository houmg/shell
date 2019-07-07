#!/bin/bash

#note：list文件中每行仅有一个ip地址，list文件放置在与本脚本同一个目录后执行
#time：2019-07-07
#outhor：houge

while read a;
do
    arr[x++]=""${a};
done < list

j="${#arr[@]}"
trap "exec 1000>&-;exec 1000<&-;exit 0" 2
tempfifo=$$.fifo
mkfifo $tempfifo
exec 1000<>$tempfifo
rm -rf $tempfifo
thred=20000
for ((i=1; i<=${thred}; i++))
do
   echo >&1000
done


for (( k=0; k<=$(($j-1)); k++ ))
do
   read -u1000
   {
    JsonResult=`curl -s http://ip-api.com/json/${arr[$k]}`
    countryCode=`echo $JsonResult | sed 's/,/\n/g' | tr -d "{}\"" | grep countryCode:|awk -F : '{print $2}'`
    country=`echo $JsonResult | sed 's/,/\n/g' | tr -d "{}\"" | grep country:|awk -F : '{print $2}'`
    city=`echo $JsonResult | sed 's/,/\n/g' | tr -d "{}\"" | grep city:|awk -F : '{print $2}'`
    printf "%-15s\t%-8s\t%-8s\t%-8s\n" "${arr[$k]}" "$countryCode" "$country" "$city" >> ip.txt
    echo >&1000
   } &
done
wait
exec 1000<&-
exec 1000>&-
echo "done!"
