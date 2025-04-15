#!/bin/bash

# 打印脚本开始
echo "开始解决编译问题..."

# 安装必要的依赖项
echo "安装必要的依赖项..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    libuuid-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libz-dev \
    libssl-dev \
    libxml2-dev \
    libtiff-dev \
    python3-dev \
    libglib2.0-dev \
    pkg-config \
    cmake \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    libtool \
    wget \
    flex \
    bison \
    gperf \
    libc-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    gawk \
    liblzma-dev \
    uuid-dev \
    libboost-all-dev

# 清理之前的构建缓存
echo "清理旧的构建缓存..."
make clean
make distclean

# 配置环境变量
echo "配置环境变量..."
echo "export PATH=/usr/local/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc

# 重新配置并构建项目
echo "重新配置并构建..."
./configure --prefix=/usr/local --enable-debug
if [ $? -ne 0 ]; then
    echo "配置失败，请检查配置错误"
    exit 1
fi

# 编译并安装
echo "编译并安装..."
make -j$(nproc) # 使用所有可用的核心进行并行编译
if [ $? -ne 0 ]; then
    echo "编译失败，请检查错误日志"
    exit 1
fi

# 安装完成的项目
echo "安装完成的项目..."
sudo make install

# 确认安装成功
echo "安装成功！"

# 打印日志文件的位置
echo "请检查构建目录中的 config.log 以了解详细的错误信息"
