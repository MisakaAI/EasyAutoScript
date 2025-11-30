#!/bin/bash

# localhost
export ALL_PROXY="socks5://127.0.0.1:7890"
export http_proxy="socks5://127.0.0.1:7890"
export https_proxy="socks5://127.0.0.1:7890"

git config --global http.proxy 'socks5://127.0.0.1:7890'
git config --global https.proxy 'socks5://127.0.0.1:7890'

# LAN
export ALL_PROXY="socks5://192.168.0.10:7890"
export http_proxy="socks5://192.168.0.10:7890"
export https_proxy="socks5://192.168.0.10:7890"

git config --global http.proxy 'socks5://192.168.0.10:7890'
git config --global https.proxy 'socks5://192.168.0.10:7890'

## unset proxy in git repository
# git config --global --unset http.proxy
# git config --global --unset https.proxy
