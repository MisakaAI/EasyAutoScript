# zsh

apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
sh -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc'
sh -c 'echo "setopt no_nomatch" >> /etc/zsh/zshrc'
sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zsh/zshrc'
sh -c 'echo "plugins=(zsh-autosuggestions)" >> /etc/zsh/zshrc'
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
# omz theme set ys