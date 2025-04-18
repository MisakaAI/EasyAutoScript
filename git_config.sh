#!/bin/bash

git config --global user.name "MisakaAI"
git config --global user.email "ai@misaka.cn"

git config --global color.ui true # 让Git适当的显示颜色
git config --global push.default simple # 只会推送本地当前分支，如果上游分支的名称与本地分支不同，则拒绝推送。
git config --global core.autocrlf input # push 时把 CRLF 转换成 LF，pull 时不转换
git config --global core.safecrlf true # 拒绝提交包含混合换行符的文件
git config --global safe.directory '*' # 安全的存储库 所有文件夹
git config --global core.quotepath false # 中文文件名或者路径不转义
git config --global core.editor vim # 改默认的编辑器
git config --global format.pretty oneline # 显示历史记录时，每个提交的信息只显示一行
git config --global credential.helper store # 使用 Git 进行身份验证时会记住凭据（用户名和密码）

git config --global -l

## set global proxy
# git config --global http.proxy 'socks5://127.0.0.1:1080'
# git config --global https.proxy 'socks5://127.0.0.1:1080'

## unset global proxy
# git config --global --unset http.proxy
# git config --global --unset https.proxy

## set proxy in git repository
# git config --local http.proxy 'socks5://127.0.0.1:1080'
# git config --local https.proxy 'socks5://127.0.0.1:1080'

## unset proxy in git repository
# git config --local --unset http.proxy
# git config --local --unset https.proxy
