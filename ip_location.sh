#!/bin/bash

#note：list文件中每行仅有一个ip地址，list文件放置在与本脚本同一个目录后执行
#time：2019-07-01
#outhor：houge

ipInfo() {
  i=0;
  s=`cat list|wc -l`;
  for ip in `cat list`
  do
    JsonDate=`curl -s http://ip-api.com/json/$ip`
    countryCode=`echo $JsonDate | sed 's/,/\n/g' | tr -d "{}\"" | grep countryCode:|awk -F : '{print $2}'`
    country=`echo $JsonDate | sed 's/,/\n/g' | tr -d "{}\"" | grep country:|awk -F : '{print $2}'`
    city=`echo $JsonDate | sed 's/,/\n/g' | tr -d "{}\"" | grep city:|awk -F : '{print $2}'`

    printf "%-15s\t%-8s\t%-8s\t%-8s\n" "$ip" "$countryCode" "$country" "$city" >> ip_location.txt  #报存为文件
    let i=i+1
    printf "%d/%d\r" "$i" "$s"    #程序执行进度 
  done
}

ipInfo;
printf "process completly\n"  
