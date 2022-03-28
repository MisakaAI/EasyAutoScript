#!/bin/bash
# Let's Encrypt - Certbot
## https://certbot.eff.org/

# 安装 snap
sudo apt update
sudo apt install -y snapd

# 注销并重新登录，或重新启动系统，以确保正确更新 snap 的路径

# 确保您的 snapd 版本是最新的
sudo snap install core
sudo snap refresh core

# 删除 certbot-auto 和任何 Certbot OS 包
sudo apt-get remove certbot

# 安装 Certbot
sudo snap install --classic certbot

# 准备 Certbot 命令
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# 运行此命令以获取证书并让 Certbot 自动编辑您的 Nginx 配置以提供服务
sudo certbot --nginx

# 将调试日志保存到/var/log/letsencrypt/letsencrypt.log
# 输入电子邮件地址（用于紧急续订和安全通知）
# (输入"c"取消):
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 请阅读以下服务条款：
# https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. 你必须
# 同意在ACME服务器上注册。你同意吗？
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# (Y)es/(N)o:
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 一旦您的第一份证书成功颁发，您是否愿意
# 分享你的电子邮件地址与电子前沿基金会，成立
# Let's Encrypt项目的合作伙伴和
# 机器人？我们想给你发一封电子邮件，告诉你我们加密网络的工作，
# EFF新闻、活动和支持数字自由的方式。
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# (Y)es/(N)o:
# 帐户已注册。
# 您希望为哪些名称激活HTTPS?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1: example.com
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 选择以逗号和/或空格分隔的适当数字，或保留输入
# 空白选择显示的所有选项(输入"c"取消):
# 申请example.com的证书

# 已成功接收证书。
# 证书保存在：/etc/letsencrypt/live/example.com/fullchain.pem
# 密钥保存在：/etc/letsencrypt/live/example.com/privkey.pem
# 本证书将于YYYY-MM-DD到期。
# 这些文件将在证书续订时更新。
# Certbot已设置计划任务，以便在后台自动续订此证书。
# 部署证书
# 已成功将example.com的证书部署到/etc/nginx/conf.d/default。形态
# 祝贺您已在https://example.com上成功启用HTTPS 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 如果你喜欢Certbot，请考虑支持我们的工作：
# *向ISRG捐款/让我们加密：https://letsencrypt.org/donate
# *向EFF捐款：https://eff.org/donate-le
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 测试自动续订
sudo certbot renew --dry-run

