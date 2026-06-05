#!/bin/bash

# PoNQ Docker 启动脚本

set -e

PROJECT_DIR="/home/divisor/workspace/repo/PoNQ"
DATA_DIR="/home/divisor/workspace/data"
HDD_DATA="/data/hdd/DATASETS"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== PoNQ Docker 环境管理 ===${NC}"

# 检查目录是否存在
if [ ! -d "$DATA_DIR" ]; then
    echo -e "${YELLOW}创建数据目录: $DATA_DIR${NC}"
    mkdir -p "$DATA_DIR"/ABC-20250605
    mkdir -p "$DATA_DIR"/Thingi-20250605
fi

# 检查NVIDIA Docker runtime
if ! docker info 2>/dev/null | grep -q "nvidia"; then
    echo -e "${YELLOW}警告: 未检测到NVIDIA Docker runtime${NC}"
    echo "请确保已安装 nvidia-docker2"
fi

cd "$PROJECT_DIR"

# 构建镜像（如果不存在）
if [[ "$(docker images -q ponq:latest 2> /dev/null)" == "" ]]; then
    echo -e "${GREEN}>>> 构建 Docker 镜像...${NC}"
    docker-compose build
fi

# 启动容器
echo -e "${GREEN}>>> 启动 PoNQ 容器...${NC}"
docker-compose up -d

echo -e "${GREEN}>>> 进入容器...${NC}"
docker exec -it ponq_container /bin/bash
