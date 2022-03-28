#!/usr/bin/env python3
# coding=utf-8

# https://www.v2fly.org/guide/start.html
# https://guide.v2fly.org/advanced/wss_and_web.html

import platform
import os
import sys
import uuid
import json
from pathlib import Path

# 获取文件所在目录
PWD = Path(__file__).resolve().parent
INSTALL_FILE = 'install-release.sh'
LOCAL_FILE = 'v2ray-linux-64.zip'
BIN_DIR = Path('/usr/local/bin')
ETC_DIR = Path('/usr/local/etc/v2ray')
V2RAY_DIR = Path('/var/v2ray')

# 看电脑系统是不是Linux，如果不是就退出
if platform.system() != 'Linux':
    print('This computer\'s system is not Linux')
    # exit()

# 选择安装模式


def mode():
    print("Please select the content to install.")
    print("1. Server - WebSocket + TLS + Web")
    print("2. Client - Proxy Socks")
    print("3. Client - Proxy Shadowsocks & Socks")
    return input('>>> ')


# 如果输入的安装模式不是123，则要求重新输入
INSTALL_MODE = mode()
if INSTALL_MODE not in ['1', '2', '3']:
    print('You must enter 1 or 2 or 3')
    INSTALL_MODE = mode()

# 获取我的配置，如果配置文件不存在，则手动输入
if (PWD/'my.json').exists():
    with open(PWD/'my.json', 'r') as f:
        my = json.load(f)
    PORT = int(my["PORT"])
    EMIL = my["EMIL"]
    PASSWORD = my["PASSWORD"]
    URL = my["URL"]
    UUID = str(uuid.uuid5(uuid.NAMESPACE_DNS, my["UUID"]))
    PATH = '/' + my["PATH"]
else:
    URL = input('URL: ')
    PORT = int(input('Port: '))
    UUID = str(uuid.uuid5(uuid.NAMESPACE_DNS, input('UUID_Keyword: ')))
    PATH = '/' + input('Path: ')
    if INSTALL_MODE in ['1', '3']:
        EMIL = input('E-mail: ')
        PASSWORD = input('Password: ')

# 读取配置文件，并加载数据


def install(INSTALL_MODE):
    # 如果安装模式为1，则安装模式为服务端
    config = {}
    if not V2RAY_DIR.exists():
        os.system("mkdir -p %s" % V2RAY_DIR)
        os.system("chown nobody:nogroup %s" % V2RAY_DIR)
    config['log'] = {
        "access": str(V2RAY_DIR/"access.log"),
        "error": str(V2RAY_DIR/"error.log"),
        "loglevel": "warning"
    }
    if INSTALL_MODE == '1':
        config['inbounds'] = [{
            "listen": "127.0.0.1",
            "port": PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "email": EMIL,
                        "id": UUID,
                        "level": 0,
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": PATH,
                }
            }}]

        config['outbounds'] = [{
            "protocol": "freedom",
            "settings": {}
        }]
    # 否则为客户端
    else:
        config['inbounds'] = [
            {
                "port": 1080,
                "listen": "0.0.0.0",
                "protocol": "socks",
                "sniffing": {
                    "enabled": True,
                    "destOverride": [
                        "http",
                        "tls"
                    ]
                },
                "settings": {
                    "auth": "noauth",
                    "udp": False
                }
            }
        ]
        config['outbounds'] = [
            {
                "protocol": "vmess",
                "settings": {
                    "vnext": [
                        {
                            "address": URL,
                            "port": 443,
                            "users": [
                                {
                                    "id": UUID,
                                    "alterId": 0
                                }
                            ]
                        }
                    ]
                },
                "streamSettings": {
                    "network": "ws",
                    "security": "tls",
                    "wsSettings": {
                        "path": PATH
                    }
                }
            }
        ]
        # 如果安装模式为2，去掉Shadowsocks
        if INSTALL_MODE == '3':
            config['inbounds'].append({
                "port": 12450,
                "protocol": "shadowsocks",
                "settings": {
                    "email": EMIL,
                    "method": "aes-256-gcm",
                    "password": PASSWORD,
                    "level": 0,
                    "network": "tcp",
                    "ivCheck": True
                }
            })
    return config

def NO_EXISTS():
    print("Please install the V2ray first.")
    print("$ bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)")
    exit()

# 写入配置文件
def dump_config(config):
    if (BIN_DIR/'v2ray').exists():
        with open(ETC_DIR/'config.json', 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
    else:
        NO_EXISTS()

def nginx_config():

    print("""
    location /""" + PATH + """ {
        # WebSocket协商失败时返回404
        if ($http_upgrade != "websocket") {
            return 404;
        }
        proxy_redirect off;
        proxy_pass http://127.0.0.1:""" + PORT + """;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        # Show real IP in v2ray access.log
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
        listen [::]:443 ssl;
    """)

# 开始安装
try:
    if (BIN_DIR/"v2ray").exists():
        print('v2ray is already installed.')
    else:
        if 'auto' in sys.argv:
            os.system(
                "curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh")
            os.system("bash install-release.sh")
            os.system("rm install-release.sh")
        elif 'local' in sys.argv:
            for i in [INSTALL_FILE, LOCAL_FILE]:
                if not (PWD/i).exists():
                    print('ERROR: "%s" file not found' % i)
                    exit()
            else:
                os.system('bash ' + str(PWD/INSTALL_FILE) +
                          ' --local ' + str(PWD/LOCAL_FILE))
        else:
            print("Please install the v2ray first.")
            print("$ bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)")
            exit()
    # 配置文件
    dump_config(install(INSTALL_MODE))
    nginx_config()
    # 启动服务
    os.system('systemctl start v2ray.service')
    os.system('systemctl restart v2ray.service')
    # 开机启动
    os.system('systemctl enable v2ray.service')
except:
    print("ERROR.")
