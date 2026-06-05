FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel

# 避免交互式配置提示
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安装系统依赖（包括CGAL）
RUN apt-get update && apt-get install -y \
    git \
    wget \
    cmake \
    build-essential \
    libgmp-dev \
    libmpfr-dev \
    libboost-all-dev \
    libcgal-dev \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /workspace

# 安装Python依赖
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# 安装PyTorch（确保版本匹配）
RUN pip install --no-cache-dir \
    torch==1.12.1+cu113 \
    torchvision==0.13.1+cu113 \
    -f https://download.pytorch.org/whl/torch_stable.html

# 安装PyTorch3D（官方预编译wheel）
RUN pip install --no-cache-dir fvcore iopath
RUN pip install --no-cache-dir pytorch3d==0.7.0 -f \
    https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py39_cu113_pyt1121/download.html

# 安装其他依赖
RUN pip install --no-cache-dir \
    trimesh==3.15.5 \
    pyigl==2.2.1 \
    tqdm==4.64.1 \
    pyyaml==6.0 \
    scikit-learn==0.19.3 \
    h5py \
    joblib \
    jupyter \
    notebook \
    gdown

# 创建必要的目录
RUN mkdir -p /workspace/data /workspace/DATASETS

# 设置环境变量
ENV PYTHONPATH=/workspace/PoNQ:$PYTHONPATH

# 暴露端口
EXPOSE 8888 6006

WORKDIR /workspace/PoNQ

# 默认启动bash
CMD ["/bin/bash"]
