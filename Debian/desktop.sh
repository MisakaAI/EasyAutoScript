#!/bin/bash

if [ "$UID" != "0" ]; then
	echo "Error: This script must be run as root !"
	exit 0
fi

apt install -y numlockx
apt install -y libreoffice
apt install -y vlc
apt install -y gimp
apt install -y inkscape
apt install -y krita
apt install -y ffmpeg
apt install -y nextcloud-desktop

# fonts
# apt install -y fonts-noto fonts-inconsolata fonts-wqy-zenhei fonts-wqy-microhei fonts-fantasque-sans
apt install -y fonts-cascadia-code

# nfs
apt install -y nfs-common

# keepass2
apt install -y keepass2 xdotool
keepass2='/usr/lib/keepass2'
mkdir $keepass2/Languages
cp Chinese_Simplified.lngx $keepass2/Languages
echo -e "<KeePass2 Auto-Type>"
echo -e "mono $keepass2/KeePass.exe --auto-type\n"

# mount
# mount.nfs 192.168.1.*:/* /mnt
# /etc/fstab
# 192.168.1.*:/*  /mnt nfs  defaults  0  0

# Google Chrome
# https://www.google.cn/chrome/

# VirtualBox
# https://www.virtualbox.org/wiki/Downloads

usermod -aG vboxusers $USER

modprobe -r kvm_intel
modprobe -r kvm
echo "
# KVM
blacklist kvm
blacklist kvm_intel" >> /etc/modprobe.d/blacklist.conf

# WPS Office
# https://www.wps.cn/product/wpslinux

# Steam
# https://store.steampowered.com/about/

# Visual Studio Code
# https://code.visualstudio.com/Download

# Tencent
# https://im.qq.com/linuxqq/index.shtml
# https://linux.weixin.qq.com/
# https://y.qq.com/download/download.html
