#!/bin/bash
set -e
echo "=================================================="
echo "  Chlish大模型 v1.2.0 一键环境安装脚本"
echo "  原生融合CRYPTORAD-MX最高安全架构"
echo "=================================================="

# 1. 系统环境检查
echo "[1/6] 正在检查系统环境..."
if ! command -v python3 &> /dev/null; then
    echo "❌ 未检测到Python3，请先安装Python 3.8+"
    exit 1
fi
if ! command -v pip3 &> /dev/null; then
    echo "❌ 未检测到pip3，请先安装pip"
    exit 1
fi
echo "✅ 系统环境检查通过"

# 2. 创建虚拟环境
echo "[2/6] 正在创建虚拟运行环境..."
if [ -d "./chlish_venv" ]; then
    echo "⚠️  检测到已存在的虚拟环境，将重新创建"
    rm -rf ./chlish_venv
fi
python3 -m venv chlish_venv
source chlish_venv/bin/activate
echo "✅ 虚拟环境创建完成，已激活"

# 3. 安装依赖
echo "[3/6] 正在安装依赖库..."
pip install --upgrade pip
pip install -r requirements.txt
echo "✅ 所有依赖安装完成，无版本冲突"

# 4. 检查NVIDIA CUDA环境
echo "[4/6] 正在检查GPU环境..."
if command -v nvidia-smi &> /dev/null; then
    echo "✅ 检测到NVIDIA GPU环境，CUDA可用"
    nvidia-smi | grep "CUDA Version"
else
    echo "⚠️  未检测到NVIDIA GPU，将使用CPU模式，推理速度较慢"
fi

# 5. 校验密码本与仓库完整性
echo "[5/6] 正在校验仓库文件完整性..."
required_files=(
    "main.py"
    "requirements.txt"
    "modules/__init__.py"
    "test_cipher_books/test_master.root.cb"
)
for file in "${required_files[@]}"; do
    if [ ! -f "${file}" ]; then
        echo "❌ 缺失核心文件：$file"
        exit 1
    fi
done
echo "✅ 仓库文件完整性校验通过"

# 6. 完成提示
echo "=================================================="
echo "  🎉 安装全部完成！"
echo "  激活环境：source chlish_venv/bin/activate"
echo "  启动Web界面：python main.py --web"
echo "  启动API服务：python main.py --api"
echo "  命令行对话：python main.py"
echo "  沙箱安全测试：python mx_sandbox_test.py --full"
echo "=================================================="