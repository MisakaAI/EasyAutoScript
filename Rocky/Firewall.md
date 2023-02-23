# Firewall

防火墙设置

## 基础信息

```bash
# 查看版本
firewall-cmd --version

# 查看帮助
firewall-cmd --help

# 显示状态
firewall-cmd --state
```

## 查看信息

```bash
# 查看所有防火墙规则
firewall-cmd --list-all-zones

# 查看当前区域防火墙规则
firewall-cmd --list-all

# 查看当前起作用的zone
firewall-cmd --get-active-zones

# 查看指定接口所属区域
firewall-cmd --get-zone-of-interface=enp2s0
```

### 信任级别

`firewall-cmd --get-active-zones`

通过Zone的值指定

- **drop**
丢弃所有进入的包，而不给出任何响应
- **block**
拒绝所有外部发起的连接，允许内部发起的连接
- **public**
允许指定的进入连接
- **external**
同上，对伪装的进入连接，一般用于路由转发
- **dmz**
允许受限制的进入连接
- **work**
允许受信任的计算机被限制的进入连接，类似 workgroup
- **home**
同上，类似 homegroup
- **internal**
同上，范围针对所有互联网用户

### 名词解释

`firewall-cmd --list-all`

- **target**
目标，这个前面学生也已经给大家介绍过了，可以理解为默认行为，有四个可选值：default、ACCEPT、%%REJECT%%、DROP，如果不设置默认为default
- **service**
这个在前面学生已经给大家解释过了，他表示一个服务
- **port**
端口，使用port可以不通过service而直接对端口进行设置
- **interface**
接口，可以理解为网卡
- **source**
源地址，可以是ip地址也可以是ip地址段
- **icmp-block**
icmp报文阻塞，可以按照icmp类型进行设置
- **masquerade**
ip地址伪装，也就是按照源网卡地址进行NAT转发
- **forward-port**
端口转发
- **rule**
自定义规则

## 添加删除 服务

–add-service 添加服务
--permanent 永久生效，没有此参数重启后失效
--zone=public 指定区域，一般都是public

```bash
# 添加开放服务规则
firewall-cmd --zone=public --permanent --add-service=ssh

# 删除开放服务规则
firewall-cmd --zone=public --permanent --remove-service=ssh

# 查看开放服务是否添加成功
firewall-cmd --zone=public --permanent --query-service=ssh

# 查看一个开放服务配置文件路径
firewall-cmd --permanent --path-service=ssh

# 查看所有打开的服务
firewall-cmd --list-services
```

## 添加删除 端口

–add-port 添加端口
--permanent 永久生效，没有此参数重启后失效
--zone=public 指定区域，一般都是public

```bash
# 添加一个开放端口规则
firewall-cmd --zone=public --permanent --add-port=2000-2010/tcp

# 删除一个开放端口规则
firewall-cmd --zone=public --permanent --remove-port=2000-2010/tcp

# 查看一个开放端口是否添加成功
firewall-cmd --zone=public --permanent --query-port=2005/tcp

# 查看所有打开的端口
firewall-cmd --list-ports
```

## 重新加载配置规则

```bash
# 修改防火墙规则后需要加载
firewall-cmd --reload
```

## 系统服务

```bash
# 启动 Firewall
systemctl start firewalld.service
# 停止 Firewall
systemctl stop firewalld.service
# 重启 Firewall
systemctl restart firewalld.service
# 查看 Firewall 状态
systemctl status firewalld.service

# 设置 Firewall 开机启动
systemctl enable firewalld.service
# 禁止 Firewall 开机启动
systemctl disable firewalld.service
# 查看 Firewall 是否开机启动
systemctl is-enabled firewalld.service

# 查看已启动的服务列表
systemctl list-unit-files | grep enabled
# 查看启动失败的服务列表
systemctl --failed
```

## 端口转发 路由

```bash
# 打开端口转发，首先需要打开IP地址伪装
firewall-cmd --zone=external --add-masquerade

# 将80端口的流量转发至8080
firewall-cmd --zone=external --add-forward-port=port=80:proto=tcp:toport=8080

# 将80端口的流量转发至192.168.0.1
firewall-cmd --zone=external --add-forward-port=proto=80:proto=tcp:toaddr=192.168.1.0.1

# 将80端口的流量转发至192.168.0.1的8080端口
firewall-cmd --zone=external --add-forward-port=proto=80:proto=tcp:toaddr=192.168.0.1:toport=8080
```

## panic

```bash
# 拒绝所有包
firewall-cmd --panic-on

# 取消拒绝状态
firewall-cmd --panic-off

# 查看是否拒绝
firewall-cmd --query-panic
```
