#!/bin/bash

# 检查是否提供了 PID
if [ -z "$1" ]; then
  echo "Usage: $0 <PID>"
  exit 1
fi

# sudo apt install psmisc
# 获取 pstree 输出，带进程和线程信息
pstree_output=$(pstree -t -a -p "$1")
#echo $pstree_output
# 输出进程树并为每个进程和线程打印亲和性
echo "$pstree_output" | while read -r line; do
  # 获取进程的 PID
  pid=$(echo "$line" |awk -F',' '{print $2}' |sed -E 's/([0-9]+) .*/\1/')
  #echo $pid
  # 如果是进程，获取其亲和性
  if [ -n "$pid" ]; then
    affinity=$(taskset -cp "$pid" 2>/dev/null)
    # 如果能获取到亲和性，输出
    if [ -n "$affinity" ]; then
      echo -e "$line \t\t Affinity: $affinity"
    else
      echo -e "$line \t\t Affinity: Unable to fetch"
    fi
  fi
done
