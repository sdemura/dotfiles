#!/usr/bin/env bash

set -ex

mkdir -p ~/.config/{nvim,kitty}

ln -sf ~/.dotfiles/init.lua ~/.config/nvim/init.lua
ln -sf ~/.dotfiles/lua ~/.config/nvim/lua
ln -sf ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -sf ~/.dotfiles/themes ~/.config/kitty/themes
