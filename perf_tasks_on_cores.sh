#!/bin/bash

# 假设你已经有这些进程和其亲和性
affinities=(0 28 56 84 112 140 168 196 224 252 280 308 336 364 392 420)

# 对每个 PID 和 Affinity 进行处理
for i in "${!affinities[@]}"; do
  affinity=${affinities[$i]}

  # 找到下一个绑定核心的位掩码
  # 这里我们用 bash 数学计算来找出下一个核心
  next_core=$((affinity + 1))  # 直接加 1 作为下一个核心

  # 输出新亲和性并筛选 ps 结果
  echo "next core: $next_core"
  
  # 运行 ps 命令来获取该核心上的进程
  ps -eo pid,psr,comm,%cpu --sort=-%cpu | awk -v next_core=$next_core '$2 == next_core && $4 > 5'
done
