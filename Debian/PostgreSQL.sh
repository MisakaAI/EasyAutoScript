#!/bin/bash
# PostgreSQL / Debian 10

# 创建文件存储库配置：
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# 导入存储库签名密钥：
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# 更新包列表：
sudo apt-get update

# 安装最新版本的 PostgreSQL。
sudo apt-get -y install postgresql

# 开启数据库服务器
pg_ctlcluster 13 main start

# 启动服务
systemctl start postgresql

# 开机启动
systemctl enable postgresql

# 服务状态
systemctl status postgresql

##  /etc/postgresql/13/main/postgresql.conf
# listen_addresses = '*'
# port = 5432
find / -name postgresql.conf

##  /etc/postgresql/13/main/pg_hba.conf
# host      all     all     all     md5
find / -name pg_hba.conf

# 安装客户端
apt install -y postgresql-client

# 连接到数据库
# su -c psql - postgres
psql -h localhost -U postgres -p 5432
