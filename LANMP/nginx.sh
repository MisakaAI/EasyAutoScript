#!/bin/bash
# Ningx / Ubuntu
# http://nginx.org/en/linux_packages.html#Ubuntu

# 安装依赖
sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# 导入官方 nginx 签名密钥，以便 apt 可以验证包的真实性。
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# 稳定的 nginx 存储库
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

# 主线的 nginx 存储库
# echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
# http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
#     | sudo tee /etc/apt/sources.list.d/nginx.list

# 设置存储库固定以更喜欢我们的包而不是分发提供的包

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

# 安装 nginx
sudo apt update
sudo apt install -y nginx

# 启动服务
systemctl start nginx

# 开机启动
systemctl enable nginx

# 查看状态
systemctl status nginx