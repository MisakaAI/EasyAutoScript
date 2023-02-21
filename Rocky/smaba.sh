dnf install -y samba

systemctl start smb.service
systemctl enable smb.service

echo "
[samba]
    comment = Raspberry Pi Network Attached Storage
    path = /samba
    read only = no
    writable = yes
    create mask = 0777
    directory mask = 0777
    browseable = yes
    public = yes
    guest ok = yes" >> /etc/samba/smb.conf


systemctl restart smb.service

firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload