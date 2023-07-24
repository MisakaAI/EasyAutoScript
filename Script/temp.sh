#!/bin/bash

# 显示温度
# sensors
# 仅显示 k10temp-pci-00c3 的温度
# sensors | grep "k10temp-pci-00c3" -A 2
# 监控温度
# watch sensors

# 读取温度值
temp1=$(cat /sys/class/hwmon/hwmon1/temp1_input)
temp2=$(cat /sys/class/hwmon/hwmon2/temp1_input)

# 将温度值转换为摄氏度
celsius1=$(awk "BEGIN {printf \"%.2f\n\", $temp1 / 1000}")
celsius2=$(awk "BEGIN {printf \"%.2f\n\", $temp2 / 1000}")

# 输出文本
echo "hwmon1: $celsius1 °C"
echo "hwmon2: $celsius2 °C"
