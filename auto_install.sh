#!/bin/bash

if [ "$UID" != "0" ]; then
	echo "Error, This script must be run as root !"
	exit 0
fi

source /etc/os-release
if [ "$ID" != "ubuntu" ]; then
	echo Error, $ID not is ubuntu.
    exit 0
fi

# function switch
update=true
# timezone=true
# locale=true
bbr=true
cpp=true
python3=true
git=true
vim=true
# vimrc=true
ssh=true
zsh=true
# omz=true
screenfetch=true
htop=true
# nginx=true
# psql=true
# nodejs=true

# Var
if [ -f "my.json" ]; then
	data=$(cat my.json | sed -r 's/",/"/' | egrep -v '^[{}]' | sed 's/"//g' | sed 's/:/=/1' | sed 's/[[:space:]]//g')
	declare $data
fi

# Update
if test -n "$update" && $update; then
    apt update
	apt upgrade -y
	apt autoremove -y
fi

# Timezone
# dpkg-reconfigure tzdata
if test -n "$timezone" && $timezone; then
	timedatectl set-timezone Asia/Shanghai
fi

# Locale
# dpkg-reconfigure locales
# locale-gen zh_CN.UTF-8
if test -n "$locale" && $locale; then
	locale-gen en_US.UTF-8
	localectl set-locale en_US.UTF-8
	echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale
fi

# BBR
if test -n "$bbr" && $bbr; then
	echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
	sysctl -p
fi

# C & C++
if test -n "$cpp" && $cpp; then
	apt install -y gcc g++ make
fi

# Python3
if test -n "$python3" && $python3; then
	apt install -y python3 python3-pip
	pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
	pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
	# update-alternatives --install /usr/bin/python python /usr/bin/python2 1
	# update-alternatives --install /usr/bin/python python /usr/bin/python3 2
	# pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
fi

# Git
if test -n "$git" && $git; then
	apt install -y git wget curl
	if test -n "$username"; then
		git config --global user.name $username
	if test -n "$mail"; then
	fi
		git config --global user.email $mail
	fi
fi

# Vim
if test -n "$vim" && $vim; then
	apt install -y vim exuberant-ctags
	if test -n "$vimrc" && $vimrc; then
		git clone --depth=1 https://github.com/MisakaAI/vim-config.git
		cd vim-config
		bash ./install.sh
		cd ..
		rm -rf vim-config
	fi
fi

# SSH
if test -n "$ssh" && $ssh; then
	apt install -y ssh openssl
	sed -i "s/#TCPKeepAlive yes/TCPKeepAlive yes\nClientAliveInterval 60\nClientAliveCountMax 120/g" /etc/ssh/sshd_config
	systemctl restart sshd.service
fi

if test -n "$ssh_key"; then
    if [ ! -d "$HOME/.ssh" ]; then
		mkdir $HOME/.ssh
	fi
	echo $ssh_key > $HOME/.ssh/authorized_keys
	chmod 600 $HOME/.ssh/authorized_keys
fi

# Zsh
if test -n "$zsh" && $zsh; then
	apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
	sh -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc'
	sh -c 'echo "setopt no_nomatch" >> /etc/zsh/zshrc'
	sh -c 'echo "zstyle \":completion:*\" rehash true" >> /etc/zsh/zshrc'
	sh -c 'echo "plugins=(zsh-autosuggestions)" >> /etc/zsh/zshrc'

	if test -n "$omz" && $omz; then
        git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
        cd ohmyzsh/tools
        REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
		sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
		# omz theme set ys
	fi
fi

# Other
if test -n "$screenfetch" && $screenfetch; then
	apt install -y screenfetch
fi
if test -n "$htop" && $htop; then
	apt install -y htop
fi

# Nginx
if test -n "$nginx" && $nginx; then
	apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
	curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
	echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
	apt update
	apt install -y nginx
	systemctl start nginx
	systemctl enable nginx
fi

# PostgreSQL
if test -n "$psql" && $psql; then
	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	apt update
	apt install -y postgresql
	systemctl start postgresql
	systemctl enable postgresql
fi

# Node.js & npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
apt install -y nodejs
npm config set registry https://registry.npmmirror.com

# Show Version
if test -n "$screenfetch" && $screenfetch; then
	screenfetch
fi
if test -n "$bbr" && $bbr; then
	echo "----- BBR -----"
	sysctl net.ipv4.tcp_available_congestion_control
	sysctl net.ipv4.tcp_congestion_control
	lsmod | grep bbr
fi
if test -n "$python3" && $python3; then
	echo "----- Python3 -----"
	python3 -V
	pip3 -V
	pip3 config list
fi
if test -n "$nginx" && $nginx; then
	echo "----- Nginx -----"
	nginx -v
fi
if test -n "$psql" && $psql; then
	echo "----- PostgreSQL -----"
	psql -V
fi
if test -n "$nodejs" && $nodejs; then
	echo "----- Node.js & npm -----"
	node -v
	npm -v
	npm config ls -l | grep registry
fi
