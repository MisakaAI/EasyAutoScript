# 清华大学镜像站
pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装常用依赖
pip install -r requirements.txt

# 更新常用依赖
pip install --upgrade -r requirements.txt