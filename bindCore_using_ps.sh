#!/bin/bash

# 获取所有进程的PID和local_rank
ps -eo pid,pcpu,cmd | grep 'llm_inference.py' | awk '$2 > 50 {print $1, $0}' | while read pid cmd; do
    # 提取local_rank
    local_rank=$(echo $cmd | grep -oP '(?<=--local_rank=)[0-9]+')
    
    # 如果找到了local_rank，则绑定到对应的核心
    if [[ -n "$local_rank" ]]; then
        # 假设绑定到CPU核，从local_rank直接对应到CPU核
        core_id=$local_rank
        echo "Binding PID $pid (local_rank=$local_rank) to CPU core $core_id"
        
        # 使用 taskset 绑定进程到对应的核心
        taskset -pc $core_id $pid
    fi
done
