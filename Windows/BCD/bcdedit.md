[BCDEdit 命令行选项](https://msdn.microsoft.com/zh-cn/library/windows/hardware/mt450468(v=vs.85).aspx)

```
# 列出固件启动项
bcdedit /enum firmware
# 删除启动项双引号内替换为对应的标识符
bcdedit /delete "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}" /f
```
