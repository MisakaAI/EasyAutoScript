# macOS

# sudo scutil --set HostName <新的主机名>
sudo scutil --set HostName Mac-mini
hostname

# homebrew
# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
xcode-select --install
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_INSTALL_FROM_API=1
# 长期替换 Homebrew Bottles 软件仓库
# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/
echo 'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"' >> ~/.zprofile
echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> ~/.zprofile
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# Homebrew Pypi
# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
export HOMEBREW_PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

# 从镜像下载安装脚本并安装 Homebrew / Linuxbrew
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

# zsh
# https://mirrors.tuna.tsinghua.edu.cn/help/ohmyzsh.git/
git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools
REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
omz theme set ys
cd ../..
rm -rf ohmyzsh
echo "setopt no_nomatch" >> ~/.zshrc
echo "zstyle \":completion:*\" rehash true" >> ~/.zshrc
brew install zsh-syntax-highlighting
echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# git
bash git_config.sh

# vim
bash vim.sh
