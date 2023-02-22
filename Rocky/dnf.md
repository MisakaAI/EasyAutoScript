# dnf

DNF是一款Linux软件包管理工具，用于管理RPM软件包。
DNF可以查询软件包信息，从指定软件库获取软件包，自动处理依赖关系以安装或卸载软件包，以及更新系统到最新可用版本。

DNF与YUM完全兼容，提供了YUM兼容的命令行以及为扩展和插件提供的API。
使用DNF需要管理员权限。

## 检查并更新

```bash
# 显示当前系统可用的更新
dnf check-update

# 创建元数据缓存
dnf makecache

# 更新所有的包和它们的依赖
dnf update
```

## 修改配置文件

```bash
# 显示当前的配置信息
dnf config-manager --dump
```

## 添加、启用和禁用软件源

```bash
# 查看启用的软件源
# dnf repolist all | grep enabled
dnf repolist

# 添加软件源
dnf config-manager --add-repo repository_url

# 启用软件源
dnf config-manager --set-enable repository

# 禁用软件源
dnf config-manager --set-disable glob_expression
```

## 管理软件包

```bash
# 列出已经安装的RPM包
dnf list installed

# 搜索某包 (以搜索nginx为例)
dnf search nginx

# 查看某包的详情
dnf info nginx

# 安装包
dnf install nginx

# 删除包
dnf remove nginx

# 删除无用孤立的软件包
dnf autoremove
```

## 管理软件包组

```bash
# 列出所有软件包组和它们的组ID
dnf group list

# 显示软件包组信息
dnf group info glob_expression

# 安装软件包组
dnf group install group_name
dnf group install groupid

# 删除软件包组
dnf group remove group_name
dnf group remove groupid
```

## 参考文献

[使用DNF管理软件包](https://docs.openeuler.org/zh/docs/22.03_LTS/docs/Administration/%E4%BD%BF%E7%94%A8DNF%E7%AE%A1%E7%90%86%E8%BD%AF%E4%BB%B6%E5%8C%85.html)