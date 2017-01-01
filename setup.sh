#!/bin/bash

# TMUX
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

# NVIM
pip3 install neovim
pip install neovim
mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
git clone https://github.com:VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
