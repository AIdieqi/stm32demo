#!/bin/bash

# 注意事项：使用脚本的时候，请不要修改工程里的ioc文件名哦，否则会找不到文件的呢，仅此而已

# 获取当前脚本所在目录
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# 从当前目录开始，向上查找直到找到 CMakeLists.txt 文件，确定项目根目录
PROJECT_DIR=$SCRIPT_DIR
while [ ! -f "$PROJECT_DIR/CMakeLists.txt" ]; do
    PROJECT_DIR=$(dirname "$PROJECT_DIR")
done

# 查找 .ioc 文件并获取其前缀作为项目名称
IOC_FILE=$(find "$PROJECT_DIR" -maxdepth 1 -name "*.ioc" | head -n 1)
if [ -z "$IOC_FILE" ]; then
    echo "哎呀，找不到 .ioc 文件呢，检查一下文件名有没有改动过哦~"
    exit 1
fi
PROJECT_NAME=$(basename "$IOC_FILE" .ioc)

echo "项目根目录名称是：$PROJECT_NAME"

# 删除原有的构建目录
BUILD_DIR="$PROJECT_DIR/build"
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

# 创建并进入构建目录
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# 运行 CMake 配置和编译项目
cmake ..
time make -j $(nproc)

# 根据项目名称生成 ELF、BIN 和 HEX 文件路径
ELF_FILE="$BUILD_DIR/${PROJECT_NAME}.elf"
BIN_FILE="$BUILD_DIR/${PROJECT_NAME}.bin"
HEX_FILE="$BUILD_DIR/${PROJECT_NAME}.hex"

# 检查 ELF 文件是否生成成功
if [ -f "$ELF_FILE" ]; then
    # 将 ELF 文件转换为 BIN 文件和 HEX 文件
    arm-none-eabi-objcopy -O binary "$ELF_FILE" "$BIN_FILE"
    arm-none-eabi-objcopy -O ihex "$ELF_FILE" "$HEX_FILE"
    echo "（吹出泡泡裹住hex文件）抓住魔法泡泡！把它轻轻放在板子先生的鼻尖上～✨"
else
    echo "（唱儿歌转圈圈）ELF捉迷藏~找呀找~找到就奖励小熊编译器抱抱~"
    exit 1
fi

# 删除ELF、BIN 和 HEX 文件之外的所有文件和文件夹
# find "$BUILD_DIR" -type f ! -name "${PROJECT_NAME}.elf" ! -name "${PROJECT_NAME}.bin" ! -name "${PROJECT_NAME}.hex" -delete
# find "$BUILD_DIR" -type d -empty -delete

# ========== 烧录配置 ==========
echo "（吹泡泡魔法启动）正在给板子先生穿水晶鞋...～✨"

# 指定flash.cfg路径（假设在项目根目录）
FLASH_CFG="$PROJECT_DIR/flash.cfg"

# 检查配置文件是否存在
if [ ! -f "$FLASH_CFG" ]; then
    echo "（泡泡破了）找不到flash.cfg文件！检查路径：$FLASH_CFG"
    exit 1
fi

# 执行烧录（使用绝对路径）
if openocd -f "$FLASH_CFG"; then
    echo "      （泡泡变身彩虹桥）
✨\(≧ω≦)♪ 烧录成功！板子先生跳起圆舞曲啦~✨"
else
    echo "（泡泡变成乌云）
烧录失败！检查ST-Link连接和配置"
    exit 1
fi

# 使用方法：
# 1. 将该脚本放在项目根目录下  
# 2. 运行脚本：./build.sh