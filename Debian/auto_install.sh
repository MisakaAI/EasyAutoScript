#!/bin/bash

# 用于 Ubuntu 22.04 系统安装后的自动配置环境。

# 配置变量
username=''
usermail=''
# ssh_key=''

# 检测是否是 ROOT 用户
if [ "$UID" != "0" ]; then
	echo "Error, This script must be run as root !"
	exit 0
fi

# 检测系统是否是 Ubuntu
source /etc/os-release
if [ "$ID" != "ubuntu" ]; then
	echo Error, $ID not is ubuntu.
    exit 0
fi

# 检测软件源是否存在备份，如果不存在则创建。

if [ ! -f /etc/apt/sources.list.bak ]
then
    sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
else
    sudo cp -a /etc/apt/sources.list.bak /etc/apt/sources.list
fi

# 选择软件源

# 如果不支持 https
# apt install apt-transport-https ca-certificates

mirrors() {
    echo "Please set source."
    echo '1. TUNA - mirrors.tuna.tsinghua.edu.cn'
    # https://mirrors.tuna.tsinghua.edu.cn/help/debian/
    echo '2. Aliyun - mirrors.aliyun.com'
    echo '3. Huawei - repo.huaweicloud.com'
    read mode
}

mirrors
while [ $mode != 1 ] && [ $mode != 2 ] && [ $mode != 3 ]
do
    mirrors
done

if [ $mode == 1 ]
then
    sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
    sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
elif [ $mode == 2 ]
then
    sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.aliyun.com@g" /etc/apt/sources.list
    sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.aliyun.com@g" /etc/apt/sources.list
elif [ $mode == 3 ]
then
    sudo sed -i "s@http://.*archive.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
    sudo sed -i "s@http://.*security.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
fi

# 更新软件源

apt update
apt upgrade -y
apt autoremove -y

# 设置系统时区为 亚洲/上海
# dpkg-reconfigure tzdata
timedatectl set-timezone Asia/Shanghai

# 设置系统语言为 en_US.UTF-8
# dpkg-reconfigure locales
# locale-gen zh_CN.UTF-8
locale-gen en_US.UTF-8
localectl set-locale en_US.UTF-8
echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale

# BBR
cat /etc/sysctl.conf | grep bbr
if [ $? != 0 ]
then
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p
fi

# C & C++
apt install -y gcc g++ make

# Python3
apt install -y python3 python3-dev python3-pip python3-venv
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
# update-alternatives --install /usr/bin/python python /usr/bin/python2 2

# Ubuntu 23.04 / Debian12 开始，不再允许虚拟环境之外的 pip install
# 可以使用 --break-system-packages 跳过系统限制强制安装
# python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
# pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

# Git
apt install -y git wget curl

git config --global user.name $username
git config --global user.email $usermail

git config --global color.ui true
git config --global push.default simple
git config --global core.autocrlf input

# Vim
apt install -y vim exuberant-ctags

# SSH
apt install -y ssh openssl

# 防止SSH自动断开
sed -i "s/#TCPKeepAlive yes/TCPKeepAlive yes\nClientAliveInterval 60\nClientAliveCountMax 120/g" /etc/ssh/sshd_config

# ROOT用户可以SSH登录
# sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

systemctl restart ssh.service

# 设置密钥登陆
if test -n "$ssh_key"; then
    if [ ! -d "$HOME/.ssh" ]; then
		mkdir $HOME/.ssh
	fi
	echo $ssh_key > $HOME/.ssh/authorized_keys
	chmod 600 $HOME/.ssh/authorized_keys
fi

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
apt install -y screenfetch htop

# apt install ffmpeg
# apt install tmux screen
# apt install nmap
# apt install unzip
# apt install samba
# apt install wakeonlan

# Show Version
screenfetch
echo "----- BBR -----"
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
lsmod | grep bbr
echo "----- Python -----"
python3 -V
pip3 -V
pip3 config list