# 适用于 Linux 的 Windows 子系统

## 安装

[安装 WSL](https://docs.microsoft.com/zh-cn/windows/wsl/install)

```PowerShell
# 查看可用 Linux 发行版列表
wsl -l -o
# 指定发行版
wsl --install -d <Distribution Name>
# 检查正在运行的 WSL 版本
wsl -l -v
# 从 WSL 1 升级到 WSL 2
wsl --set-version <distro name> 2
```
