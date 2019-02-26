#!/bin/bash
# Linux + Apache + PostgreSQL + PHP

# Apache2
sudo apt -y install apache2

# PostgreSQL
sudo apt -y install postgresql

# PHP
sudo apt -y install php php-pgsql libapache2-mod-php
sudo apt -y install php-zip php-xml php-intl php-gd php-curl php-mbstring php-apcu php-intl

# PostgreSQL Settings
sudo sed -i '85,90s/peer/md5/g' `find / -name pg_hba.conf`
sudo sed -i '85,90s/ident/md5/g' `find / -name pg_hba.conf`
