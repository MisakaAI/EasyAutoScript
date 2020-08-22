#!/bin/bash
# Linux + Nginx + PostgreSQL + PHP

# Nginx
sudo apt-get install -y nginx

# PostgreSQL
sudo apt-get install -y postgresql
pg_ctlcluster 11 main start

# PHP
sudo apt-get install -y php-fpm php-pgsql
sudo apt-get install -y php-zip php-xml php-intl php-gd php-curl php-mbstring php-apcu php-intl php-pear php-json php-cgi

# PostgreSQL Settings
find / -name pg_hba.conf
sudo sed -i '85,90s/peer/md5/g' /etc/postgresql/11/main/pg_hba.conf
sudo sed -i '85,90s/ident/md5/g' /etc/postgresql/11/main/pg_hba.conf
systemctl restart postgresql.service
