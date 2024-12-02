#!/bin/bash

# 设置仓库 URL 和目标目录
REPO_URL="https://github.com/your/repository.git"
TARGET_DIR="your_directory"

# 无限重试直到成功
while true; do
  git clone $REPO_URL $TARGET_DIR
  if [ $? -eq 0 ]; then
    echo "Git clone 成功！"
    break
  else
    echo "Git clone 失败，正在重试..."
    sleep 5  # 等待 5 秒后重试
  fi
done
