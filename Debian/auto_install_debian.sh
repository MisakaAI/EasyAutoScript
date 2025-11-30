#!/bin/bash

# 用于 Debian 13 trixie 系统安装后的自动配置环境。
# 检测是否是 ROOT 用户
if [ "$UID" != "0" ]; then
	echo "Error, This script must be run as root !"
	exit 0
fi

# 检测系统是否是 Ubuntu
source /etc/os-release
if [ "$ID" != "debian" ]; then
	echo Error, $ID not is debian.
    exit 0
fi

# 检测软件源是否存在备份，如果不存在则创建。

if [ ! -f /etc/apt/sources.list.bak ]
then
    cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
else
    cp -a /etc/apt/sources.list.bak /etc/apt/sources.list
fi

# 选择软件源
echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib" > /etc/apt/sources.list

# 支持 https
apt install apt-transport-https ca-certificates -y

# 清华大学镜像站
echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib non-free non-free-firmware" > /etc/apt/sources.list

# 更新软件源
apt update && apt upgrade -y && apt autoremove -y

# 设置系统时区为 亚洲/上海
# dpkg-reconfigure tzdata
timedatectl set-timezone Asia/Shanghai

# 设置系统语言为 en_US.UTF-8
# dpkg-reconfigure locales
# locale-gen zh_CN.UTF-8
locale-gen en_US.UTF-8
localectl set-locale en_US.UTF-8
echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale

# C & C++
apt install -y build-essential cmake

# Python3
apt install -y python3 python3-dev python3-pip python3-venv
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
curl -LsSf https://astral.sh/uv/install.sh | sh

# Git
apt install -y git wget curl

# Vim
apt install -y vim exuberant-ctags

# SSH
apt install -y ssh

# 防止SSH自动断开
sed -i "s/#TCPKeepAlive yes/TCPKeepAlive yes\nClientAliveInterval 60\nClientAliveCountMax 120/g" /etc/ssh/sshd_config

# ROOT用户可以SSH登录
# sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

systemctl restart sshd.service

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

# Other
apt install -y htop tmux screen
