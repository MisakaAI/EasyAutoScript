#!/bin/bash

# 操作系统 + 网页服务器 + 数据库服务器 + 脚本语言
# Linux + Apache/Nginx + Mysql/Mariadb/PostgreSQL + PHP/Python

################
## PostgreSQL ##
################

# https://www.postgresql.org/download/linux/ubuntu/
# https://www.postgresql.org/download/linux/debian/

# sudo sh -c 'echo "deb https://mirrors.tuna.tsinghua.edu.cn/postgresql/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# wget --quiet -O - https://mirrors.tuna.tsinghua.edu.cn/postgresql/repos/apt/ACCC4CF8.asc | sudo apt-key add -
apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://mirrors.aliyun.com/postgresql/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
sudo apt update
sudo apt install postgresql

sudo -u postgres psql

# E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation
# apt install gnupg2

# W: https://mirrors.tuna.tsinghua.edu.cn/postgresql/repos/apt/dists/bookworm-pgdg/InRelease: 密钥存储在过时的 trusted.gpg 密钥环中（/etc/apt/trusted.gpg），请参见 apt-key(8) 的 DEPRECATION 一节以了解详情。
# mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

#############
## MariaDB ##
#############

# 在官方页面上生成配置文件内容
# https://mariadb.org/download/?t=repo-config

sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.10/ubuntu jammy main' >>/etc/apt/sources.list"

apt update
apt install mariadb-server

############
## Apache ##
############

# https://httpd.apache.org/docs/2.4/install.html

apt install apache2
systemctl start apache2.service
systemctl enable apache2.service

###########
## Nginx ##
###########


# 安装必备组件

# http://nginx.org/en/linux_packages.html#Ubuntu
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
# https://nginx.org/en/linux_packages.html#Debian
sudo apt install curl gnupg2 ca-certificates lsb-release debian-archive-keyring

# 导入一个正式的nginx签名密钥，以便apt可以验证软件包 真实性。
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# 设置apt存储库

# 使用稳定的 Nginx 包
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

# 使用主线 Nginx 包
# echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
# http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
#     | sudo tee /etc/apt/sources.list.d/nginx.list

# 设置存储库固定以优先选择 Nginx 官方的包
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

# 安装
apt update
apt install nginx -y

systemctl start nginx.service
systemctl enable nginx.service

#########
## PHP ##
#########

# 安装 PHP
# apt install php-common php-cli

# FastCGI Process Manager
apt install php-fpm

# 支持 MySQL
apt install php-mysql

# 支持 PostgreSQL
apt install php-pgsql

# 常用的
apt install php-curl php-xml php-gd php-json php-mbstring php-zip php-bz2 php-intl php-gmp php-apcu php-imagick