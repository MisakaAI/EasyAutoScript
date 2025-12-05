#!/bin/bash

## Docker
# https://docs.docker.com/engine/install/debian/

# 卸载旧版本
# sudo apt remove docker docker-engine docker.io containerd runc
# 卸载所有冲突的软件包
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done

# 更新apt软件包索引并安装软件包以允许apt通过HTTPS使用存储库

sudo apt update
sudo apt install ca-certificates curl gnupg

# 添加Docker的官方GPG密钥
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 设置稳定的存储库
# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
#   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# 清华大学
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装DOCKER引擎
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 设置代理
sudo mkdir -p /etc/systemd/system/docker.service.d

echo '[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"' > /etc/systemd/system/docker.service.d/http-proxy.conf

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker

# 使用systemd 在系统启动时启动 docker
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service

# 便捷脚本
# Raspbian 必须使用脚本安装
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh

# 卸载 Docker Engine
# sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd
