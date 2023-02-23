# Kernel

## 添加 ELRepo 存储库

# 导入密钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# 安装 ELRepo
dnf install https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm

# 重建存储库缓存
dnf makecache

## 安装新的内核

# kernel-ml 为主线稳定版本（mainline stable）
# kernel-lt 为长期支持版本（long term support）

# 安装内核
dnf --enablerepo=elrepo-kernel install kernel-ml
# dnf --enablerepo=elrepo-kernel install kernel-lt

## 生成Grub2配置
# 在基于 BIOS 的机器上，输入：
# grub2-mkconfig -o /boot/grub2/grub.cfg

# 在基于 UEFI 的机器上，输入：
# grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg

# 重启系统
reboot

## 确认内核版本是否升级成功
# 确认内核版本
uname -msr

# 确认 GRUB 默认启动的内核版本
grubby --default-kernel

# 列出所有安装的内核
# grubby --info=ALL | grep ^kernel

# 列出 GRUB 可用的 Linux 内核
# ls /boot/vm*

# 为 GRUB 设置默认内核
# grubby --info ALL | grep id
# grubby --set-default /boot/vmlinuz-<version>.<architecture>

# 默认情况下，Yum Package Manager 单独安装 Linux 内核，同时保留旧版本以提供后备支持。

# 检查 installonly_limit指令的当前值。
# grep limit /etc/dnf/dnf.conf

# 删除旧内核
# dnf remove --oldinstallonly --setopt installonly_limit=2 kernel
