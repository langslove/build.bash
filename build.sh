#!/bin/bash

# 修正 PATH，移除不安全项
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# 确保在 ImmortalWrt 根目录
cd /home/langslove/immortalwrt || { echo "找不到 ImmortalWrt 目录，退出"; exit 1; }

# 清理旧编译缓存
make clean

# 更新 feeds 源并安装所有包
./scripts/feeds update -a
./scripts/feeds install -a

# 生成默认配置
make defconfig

# 开始多线程编译，带日志输出
make -j24 V=s | tee build.log
