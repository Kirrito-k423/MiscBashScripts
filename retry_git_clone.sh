#!/bin/bash

# please source this, to use terminal git http proxy
# 设置仓库 URL 和目标目录
REPO_URL="https://github.com/Kirrito-k423/pytorch.git"
BRANCH="v2.1.0_cpprinter"
TARGET_DIR="pytorch_official_v2.1.0_debug"

# 压缩
# -1：表示自动选择压缩级别，通常是一个适中的值。
# 0：禁用压缩，传输时不对数据进行压缩。这会增加网络带宽的使用，但适用于网络速度非常快的情况。
# 1 到 9：指定压缩级别。数字越大，压缩越高，但可能会增加 CPU 使用。
git config --global core.compression -1

# 500MB缓存
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

# 无限重试直到成功
while true; do
   git clone $REPO_URL -b $BRANCH $TARGET_DIR --depth=1
   if [ $? -eq 0  ]; then
       echo "Git clone 成功！"
       break
   else
       echo "Git clone 失败，正在重试..."
       sleep 5  # 等待 5 秒后重试
   fi
done
