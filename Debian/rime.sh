# Rime
# https://rime.im/

# ibus-rime
apt-get install -y ibus-rime
mkdir -p ~/.config/ibus/rime

echo "patch:
  "menu/page_size": 9
  "style/horizontal": true
  "menu/display_tray": false
  "switcher/hotkeys": ["F4"]
  ascii_composer:
    switch_key:
      Caps_Lock: commit_code
  shift_key: inline_ascii" > ~/.config/ibus/rime/default.custom.yaml

ibus-daemon -drx

# 雾凇拼音
# https://github.com/iDvel/rime-ice
cd ~
git clone https://github.com/rime/plum.git plum
cd ~/plum
bash rime-install iDvel/rime-ice:others/recipes/full

ibus-daemon -drx
ibus restart
