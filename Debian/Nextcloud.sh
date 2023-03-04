#!/bin/bash
# nextcloud

nexycloud_Version=18.0.4
nextcloud_Download="https://download.nextcloud.com/server/releases/nextcloud-$nexycloud_Version.zip"

echo -n "Enter your database name:"
read database_name
echo -n "Enter your database username:"
read database_user
echo -n "Enter your database password:"
read -s database_pass
echo -n "Enter your username of nextcloud:"
read username
echo -n "Enter your password of nextcloud:"
read -s password

# Installation dependency
apt install -y nginx
apt install -y postgresql
pg_ctlcluster 11 main start
apt install -y php-fpm php-common php-curl php-xml php-gd php-json php-mbstring php-zip php-pgsql php-bz2 php-intl php-smbclient php-gmp php-apcu php-imagick
apt install -y ffmpeg
apt install -y libreoffice libreoffice-l10n-zh-cn

# Download
wget $nextcloud_Download
unzip nextcloud-$nexycloud_Version.zip

# Installation Nextcloud
cp -r nextcloud /var/www/html
chown -R www-data:www-data /var/www/html/nextcloud/

# sudo -u www-data php /var/www/html/nextcloud/occ maintenance:update:htaccess
sudo -u www-data php occ  maintenance:install --database "pgsql" --database-name $database_name  --database-user $database_user --database-pass $database_pass --admin-user $username --admin-pass $password