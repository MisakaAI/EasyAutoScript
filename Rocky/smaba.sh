dnf install -y samba

systemctl start smb.service
systemctl enable smb.service

cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

echo "
[public]
	# 描述
	comment = samba public
	# 目录
	path = /data
	# 是否只读
	read only = no
	# 是否可写
	writable = yes
	# 新创建的文件 预设权限为 0644
	create mask = 0644
	# 新创建的目录 预设权限为 0755
	directory mask = 0755
	# 开放给其他人浏览
	browseable = yes
	# 是否让所有可以登入的用户看到这个项目
	public = yes
	guest ok = yes" >> /etc/samba/smb.conf

systemctl restart smb.service

firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload