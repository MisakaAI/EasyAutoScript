#!/usr/bin/env bash
# https://github.com/Gogh-Co/Gogh

# 
sudo apt-get install dconf-cli uuid-runtime

# Install (Interactive Mode)
# bash -c "$(wget -qO- https://git.io/vQgMr)"

# Install (Non-Interactive Mode)
# Clone the repo into "$HOME/src/gogh"
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh
cd gogh

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Enter theme installs dir
cd installs

# install themes
./kanagawa-wave.sh

# rm
rm -r "$HOME/src"