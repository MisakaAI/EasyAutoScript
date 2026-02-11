#!/bin/bash
# https://nodejs.org/zh-cn/download

# 下载并安装 nvm：
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 代替重启 shell
\. "$HOME/.nvm/nvm.sh"

# 配置 nvm 使用 npmmirror 镜像站
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node

# 下载并安装 Node.js：
# WSL 环境下会报错
nvm install 24

# 验证 Node.js 版本：
node -v

# 验证 npm 版本：
npm -v

# 配置 npm 使用 npmmirror 镜像站
# https://npmmirror.com/
npm config set registry https://registry.npmmirror.com

# Qwen3-Coder
# https://qwenlm.github.io/qwen-code-docs/zh/
npm i -g @qwen-code/qwen-code

# Codex
npm i -g @openai/codex
cat << 'EOF' >> ~/.zshrc
codex-proxy() {
  http_proxy="http://127.0.0.1:7890" \
  https_proxy="http://127.0.0.1:7890" \
  codex
}
EOF