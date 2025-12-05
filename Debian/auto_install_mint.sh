#!/bin/bash
# 用于 Linux Mint 22 系统安装后的自动配置环境。

# 检测是否是 ROOT 用户
if [ "$UID" != "0" ]; then
	echo "Error, This script must be run as root !"
	exit 0
fi

# 检测系统是否是 Linux Mint
source /etc/os-release
if [ "$ID" != "linuxmint" ]; then
	echo Error, $ID not is linux mint.
    exit 0
fi

# Linux Mint 软件仓库
# https://mirrors.tuna.tsinghua.edu.cn/help/linuxmint/
# 使用 首选像 > 软件源 进行修改
apt install apt-transport-https ca-certificates -y
cp /etc/apt/sources.list.d/official-package-repositories.list cat /etc/apt/sources.list.d/official-package-repositories.list.bak

# 更新软件源
apt update && apt upgrade -y && apt autoremove -y

# 设置系统时区为 亚洲/上海
dpkg-reconfigure tzdata

# 设置系统语言为 en_US.UTF-8
dpkg-reconfigure locales

locale-gen zh_CN.UTF-8
locale-gen en_US.UTF-8
localectl set-locale en_US.UTF-8
echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale

# C & C++
apt install -y build-essential cmake

# Python3
apt install -y python3 python3-dev python3-pip python3-venv idle
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
curl -LsSf https://astral.sh/uv/install.sh | sh

# Git
apt install -y git wget curl

# Vim
apt install -y vim exuberant-ctags

# SSH
apt install -y ssh openssl

# 防止SSH自动断开
sed -i "s/#TCPKeepAlive yes/TCPKeepAlive yes\nClientAliveInterval 60\nClientAliveCountMax 120/g" /etc/ssh/sshd_config

# ROOT用户可以SSH登录
# sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

systemctl restart ssh.service

# Zsh

apt install -y zsh zsh-syntax-highlighting # zsh-autosuggestions
cat /etc/zsh/zshrc | grep zsh-syntax-highlighting
if [ $? != 0 ]
then
    sh -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc'
    sh -c 'echo "setopt no_nomatch" >> /etc/zsh/zshrc'
    sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zsh/zshrc'
    # sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc
fi

# Oh My ZSH
git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools
REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
cd ../..
rm -rf ohmyzsh
# omz theme set ys

# Other
apt install -y htop tmux screen
