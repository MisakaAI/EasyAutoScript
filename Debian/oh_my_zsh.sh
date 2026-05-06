# oh my zsh
# https://ohmyz.sh/

# apt install -y zsh zsh-syntax-highlighting # zsh-autosuggestions
# cat /etc/zsh/zshrc | grep zsh-syntax-highlighting
# sh -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc'
# sh -c 'echo "setopt no_nomatch" >> /etc/zsh/zshrc'
# sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zsh/zshrc'
# sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
git clone https://mirror.nju.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools

# RUNZSH=no REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
RUNZSH=no REMOTE=https://mirror.nju.edu.cn/git/ohmyzsh.git sh install.sh
sed -i \
  -e "s/^# zstyle ':omz:update' mode auto/zstyle ':omz:update' mode auto/" \
  -e 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' \
  ~/.zshrc

# 切换已有 ohmyzsh 至镜像源
# git -C $ZSH remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
git -C $ZSH remote set-url origin https://mirror.nju.edu.cn/git/ohmyzsh.git
git -C $ZSH pull

# 启用自动更新
# zstyle ':omz:update' mode auto

# 设置默认主题
# omz theme set ys

# 更改远程仓库
# REMOTE=

# 更改默认 Shell
# CHSH=yes

# 运行 ZSH
# RUNZSH=no

# 跳过更改默认 Shell 和 运行 ZSH
# sh install.sh --unattended

# 修改默认Shell
# sudo chsh -s $(which zsh) $USER
