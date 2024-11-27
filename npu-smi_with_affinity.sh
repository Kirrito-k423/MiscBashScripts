#!/bin/bash

# 获取 npu-smi info 的输出
npu_smi_output=$(npu-smi info)

# 检查 npu-smi 是否执行成功
if [[ $? -ne 0 ]]; then
    echo "Error: Unable to execute npu-smi info"
    exit 1
fi

# 提取进程信息
echo "Extracting process information..."
process_list=$(echo "$npu_smi_output" | awk '/\|/ && $2 ~ /^[0-9]+$/ {print $5}'|tail -n 16)

if [[ -z "$process_list" ]]; then
    echo "No processes found in npu-smi output."
    exit 0
fi

# 遍历每个进程并显示其亲和性
echo "Checking CPU affinity for each process:"
for pid in $process_list; do
    # 检查进程是否存在
    if [[ ! -d "/proc/$pid" ]]; then
        echo "Process $pid does not exist. Skipping..."
        continue
    fi

    # 获取 CPU 亲和性
    affinity=$(taskset -cp "$pid" 2>/dev/null)

    # 如果任务信息存在，显示其亲和性
    if [[ $? -eq 0 ]]; then
        echo "PID: $pid, Affinity: $affinity"
    else
        echo "Unable to fetch affinity for PID: $pid"
    fi
done
