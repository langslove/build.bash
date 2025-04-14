#!/bin/bash

# 搜索路径
PACKAGE_DIR="./package"

# 查找所有 Makefile
MAKEFILES=$(find "$PACKAGE_DIR" -type f -name "Makefile")

echo "开始扫描 $PACKAGE_DIR 中的依赖关系..."
echo ""

for mk in $MAKEFILES; do
    package=$(grep -E '^ *PKG_NAME|^ *LUCI_TITLE|^ *define Package/.*' "$mk" | head -1 | sed 's/.*Package\///;s/ .*//;s/PKG_NAME:=//;s/ //g')
    if [ -z "$package" ]; then
        continue
    fi

    # 取出 DEPENDS 和 SELECT 字段
    depends=$(grep -E 'DEPENDS:=|\+=.*' "$mk" | sed 's/.*DEPENDS:=//;s/.*\+=//;s/ //g' | tr -d '+' | tr -d '@')
    selects=$(grep -E 'SELECT:=|\+=.*' "$mk" | sed 's/.*SELECT:=//;s/.*\+=//;s/ //g' | tr -d '+' | tr -d '@')

    # 检查自依赖
    if echo "$depends $selects" | grep -wq "$package"; then
        echo "发现自依赖：$package 依赖自身"
    fi

    # 检查依赖包是否存在
    for dep in $depends $selects; do
        if ! grep -q "Package/$dep" $MAKEFILES; then
            echo "警告：$package 依赖的 $dep 不存在"
        fi
    done
done

echo ""
echo "依赖扫描完成。"