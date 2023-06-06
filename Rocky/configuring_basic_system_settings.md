# 基本系统配置

[配置基本系统设置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/index)

## 更改主机名

```sh
hostnamectl set-hostname cndpapernews.com
```

## 更改时区

```sh
# 列出亚洲所有可用时区
timedatectl list-timezones | grep Asia

# 将时区更改为 亚洲/上海
timedatectl set-timezone Asia/Shanghai
```

## 配置系统区域设置

```sh
# 列出系统可用区域设置
localectl list-locales

# 显示系统区域设置的当前状态
localectl status

# 更改默认的系统区域设置
localectl set-locale LANG=en_US
```