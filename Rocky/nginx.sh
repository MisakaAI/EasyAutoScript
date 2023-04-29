# Nginx

# 安装必备组件
# yum install yum-utils

# 设置yum存储库

echo '[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true' > /etc/yum.repos.d/nginx.repo

# echo '[nginx-mainline]
# name=nginx mainline repo
# baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
# gpgcheck=1
# enabled=0
# gpgkey=https://nginx.org/keys/nginx_signing.key
# module_hotfixes=true' > /etc/yum.repos.d/nginx.repo

# 默认情况下，使用稳定nginx包的存储库。
# 切换 使用主线 nginx 包
# yum-config-manager --enable nginx-mainline

# To install nginx, run the following command:
dnf install nginx

# 启动
systemctl start nginx

# 开机启动
systemctl enable nginx

# 允许通过防火墙
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# 关闭SELINUX