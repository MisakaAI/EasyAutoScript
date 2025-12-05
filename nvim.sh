#!/bin/bash
# Neo Vim

# 配置代理
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
git config --global http.proxy 'socks5://127.0.0.1:7890'
git config --global https.proxy 'socks5://127.0.0.1:7890'

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> /etc/zsh/zshrc
echo "alias vim='nvim'" >> /etc/zsh/zshrc
source /etc/zsh/zshrc

# 创建配置文件
mkdir ~/.config/nvim/
touch ~/.config/nvim/init.lua
cp init.lua ~/.config/nvim/init.lua

# 安装插件管理器
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

git config --global --unset http.proxy
git config --global --unset https.proxy