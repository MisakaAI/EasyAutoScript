#!/bin/bash
source /etc/os-release
if [ "$UID" != "0" ]
then
	echo "Error, This script must be run as root !"
	exit 0
fi
if [ "$ID_LIKE" != "debian" ]
then
	echo Error, $ID not is ubuntu.
    exit 0
fi

# mv /etc/apt/sources.list /etc/apt/sources.list.bak

mirrors(){
    echo "Please set source."
    echo '1. TUNA - mirrors.tuna.tsinghua.edu.cn'
    echo '2. Aliyun - mirrors.aliyun.com'    
    read mode
}

mirrors
while [ $mode != 1 ] && [ $mode != 2 ]
do
    mirrors
done

if [ $mode == 1 ]
then
    APT_SOURCE="https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\/"
elif [ $mode == 2 ]
then
    APT_SOURCE="https:\/\/mirrors.aliyun.com\/ubuntu\/"
fi

sed -i "s/^deb.*$VERSION_CODENAME/deb $APT_SOURCE $VERSION_CODENAME/" /etc/apt/sources.list
sed -i "s/deb-src.*$VERSION_CODENAME/deb-src $APT_SOURCE $VERSION_CODENAME/" /etc/apt/sources.list

apt update && apt upgrade -y && apt autoremove -y