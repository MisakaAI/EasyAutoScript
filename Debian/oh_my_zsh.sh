# oh my zsh

# apt install -y zsh zsh-syntax-highlighting # zsh-autosuggestions
# cat /etc/zsh/zshrc | grep zsh-syntax-highlighting
# sh -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc'
# sh -c 'echo "setopt no_nomatch" >> /etc/zsh/zshrc'
# sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zsh/zshrc'
# sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
cd ohmyzsh/tools
REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
# omz theme set ys
