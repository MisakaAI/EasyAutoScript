#!/bin/bash

if [ "$UID" != "0" ]; then
	echo "Error: This script must be run as root !"
	exit 0
fi

# 将硬件时间设置为 localtime
# --adjust-system-clock 修改本地RTC模式时，需要调整系统时钟
timedatectl set-local-rtc 1 --adjust-system-clock

# 硬件时间设置成 UTC
# timedatectl set-local-rtc 0

# 网络时间同步[布尔值]
timedatectl set-ntp false

# 将系统时钟设置到硬件时钟
hwclock --systohc