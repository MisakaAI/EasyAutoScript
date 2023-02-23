# 关闭 SELinux

# vim /etc/selinux/config

# 注释掉
# SELINUX=enforcing
# SELINUXTYPE=targeted

# 增加
# SELINUX=disabled

cp /etc/selinux/config /etc/selinux/config.bak
echo "SELINUX=disabled" > /etc/selinux/config

# 使配置立即生效
setenforce 0