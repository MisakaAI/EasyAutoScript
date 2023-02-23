# Grub2

# 隐藏可引导的内核的列表
echo "GRUB_TIMEOUT_STYLE=hidden" >> /etc/default/grub

# 按 Esc 键，以显示启动时可引导内核的列表。
# 不要在 /etc/default/grub 文件中将 GRUB_TIMEOUT 设为 0 来隐藏可引导内核的列表。
# 有了这个设置，系统总是在默认菜单条目上立即引导，如果默认内核无法引导，则无法引导任何以前的内核。


# 列出可用的菜单条目
# grubby --info=ALL

# 指定默认载入哪个操作系统或内核
# grubby --set-default-index=1

# 查看默认载入哪个操作系统或内核
grubby --default-index

## 生成Grub2配置
# 在基于 BIOS 的机器上，输入：
# grub2-mkconfig -o /boot/grub2/grub.cfg

# 在基于 UEFI 的机器上，输入：
grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg