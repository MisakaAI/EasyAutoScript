#!/bin/bash

# browser-sync
# http://www.browsersync.cn/#install
npm config set registry https://registry.npmmirror.com
npm install -g browser-sync

# npm uninstall browser-sync -save

# browser-sync start --server --files "**/*.css, **/*.html"
# echo -e alias bwsync=\'browser-sync start --server --files \"**/*.css, **/*.html\"\' >> /etc/zsh/zshrc
