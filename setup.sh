#!/bin/bash

# TMUX
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# NVIM
pip3 install neovim
mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/nvim/init.vim ~/.config/nvim/init.vim
git clone git@github.com:VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
git clone git@github.com:sdemura/tmux-sensible.git ~/.dotfiles/tmux/tmux-sensible
