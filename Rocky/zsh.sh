# ZSH

dnf install -y zsh

# Oh My Zsh

git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools
REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh

# 设置默认主题为 ys
omz theme set ys

# 修改用户默认的shell
# vim /etc/passwd

# 解决zsh:no matches found 报错问题
sh -c 'echo "setopt no_nomatch" >> /etc/zshrc'

# 为每次搜索更新命令的内部列表（散列）。
# 这会导致速度损失，只有在路径中的目录文件访问速度慢时才可能明显。
sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zshrc'

# 语法高亮显示
git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd zsh-syntax-highlighting
make install
sh -c 'echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc'

# 根据历史记录和完成情况在您键入时建议命令。
# 将此存储库克隆到$ZSH_CUSTOM/plugins（默认为~/.oh-my-zsh/custom/plugins）
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 将插件添加到 Oh My Zsh 要加载的插件列表中（在~/.zshrc内）
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

# ~/.zshrc

# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="ys"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh