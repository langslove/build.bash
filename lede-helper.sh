#!/bin/bash

echo "== LEDE 编译环境检测工具 =="

# 检查基础依赖
echo "[1] 检查宿主依赖..."
for cmd in python3 g++ make perl ninja nasm pkg-config libssl-dev cmake curl rustc cargo; do
    if ! command -v $cmd &> /dev/null; then
        echo "  缺少依赖：$cmd"
        missing=1
    else
        echo "  已安装：$cmd ($(command -v $cmd))"
    fi
done
[ "$missing" == "1" ] && echo "请先安装缺少依赖再继续！" && exit 1

# 检查 Rust 版本
echo "[2] Rust 版本：$(rustc --version)"

# 检查 feeds 状态
echo "[3] 同步 feeds..."
./scripts/feeds update -a && ./scripts/feeds install -a

# 检查 defconfig
echo "[4] 检查配置 defconfig..."
make defconfig

# 检查下载
echo "[5] 校验所有源码包下载情况..."
make download -j$(nproc) V=s

# 编译 rust / node 单包测试
echo "[6] 编译测试 Rust 和 Node..."
make package/feeds/packages/rust/compile V=s || { echo "Rust 编译失败！" ; exit 1 ; }
make package/feeds/packages/node/compile V=s || { echo "Node 编译失败！" ; exit 1 ; }

# 编译完成提示
echo "✅ 环境检测、feeds、下载、Rust 和 Node 编译都通过了！"
echo "你可以继续执行： make -j$(nproc) V=s"
