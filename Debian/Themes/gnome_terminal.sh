#!/usr/bin/env bash

# 备份整个 terminal 配置
# dconf dump /org/gnome/terminal/ > terminal-backup.dconf

# 恢复
# dconf load /org/gnome/terminal/ < terminal-backup.dconf

set -e

NEW_UUID=$(uuidgen)

echo "Generated UUID: $NEW_UUID"

TMP_FILE=$(mktemp)

cat > "$TMP_FILE" <<EOF
[legacy]
default-show-menubar=false
menu-accelerator-enabled=false

[legacy/profiles:]
default='$NEW_UUID'
list=['$NEW_UUID']

[legacy/profiles:/:$NEW_UUID]
allow-bold=true
background-color='#1F1F1F1F2828'
background-transparency-percent=12
bold-color='#DCDCD7D7BABA'
bold-color-same-as-fg=true
cursor-background-color='#DCDCD7D7BABA'
cursor-colors-set=true
cursor-foreground-color='#1F1F1F1F2828'
font='Cascadia Mono NF 16'
foreground-color='#DCDCD7D7BABA'
highlight-colors-set=false
palette=['#090906061818', '#C3C340404343', '#767694946A6A', '#C0C0A3A36E6E', '#7E7E9C9CD8D8', '#95957F7FB8B8', '#6A6A95958989', '#C8C8C0C09393', '#727271716969', '#E8E824242424', '#9898BBBB6C6C', '#E6E6C3C38484', '#7F7FB4B4CACA', '#93938A8AA9A9', '#7A7AA8A89F9F', '#DCDCD7D7BABA']
scrollback-unlimited=false
use-system-font=false
use-theme-background=false
use-theme-colors=false
use-theme-transparency=false
use-transparent-background=true
visible-name='Kanagawa Wave'
EOF

echo "Importing GNOME Terminal profile..."

dconf load /org/gnome/terminal/ < "$TMP_FILE"

rm -f "$TMP_FILE"

echo "Done."