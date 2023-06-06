# PostgreSQL
# https://www.postgresql.org/download/linux/redhat/

# 安装 RPM 存储库:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# 禁用内置 PostgreSQL 模块:
sudo dnf -qy module disable postgresql

# 禁用 11-14
dnf config-manager --set-disable pgdg11 pgdg12 pgdg13 pgdg14

# Install PostgreSQL:
sudo dnf install -y postgresql15-server

# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl enable postgresql-15
sudo systemctl start postgresql-15

# 防火墙设置
# firewall-cmd --permanent --zone=public --add-port=5432/tcp
firewall-cmd --permanent --zone=public --add-service=postgresql
firewall-cmd --reload

# Python3
# pip install --upgrade pip           # upgrade pip to at least 20.3
# pip install "psycopg[binary]"

# vim  ~/.pgpass
# hostname:port:database:username:password
# chmod 0600 ~/.pgpass