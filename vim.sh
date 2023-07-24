#!/bin/bash

# apt install -y vim exuberant-ctags git
# dnf install vim ctags

git clone --depth=1 https://github.com/MisakaAI/vim-config.git
cd vim-config
bash ./install.sh
cd ..
rm -rf vim-config