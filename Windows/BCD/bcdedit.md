# 启动配置数据

Boot Configuration Data，简称BCD。

[BCDEdit 命令行选项](https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcdedit-command-line-options)

```cmd
# 列出固件启动项
bcdedit /enum firmware
# 删除启动项双引号内替换为对应的标识符
bcdedit /delete "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}" /f
```
