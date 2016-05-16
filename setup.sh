#!/bin/bash

# TMUX
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# NVIM
mkdir -p ~/.config
ln -s ~/.dotfiles/nvim/ ~/.config/nvim
ln -s ~/.dotfiles/nvim/init.vim ~/.nvimrc

