#!/bin/bash

# install neovim from somewhere

# python stuff
pip3 install black python-language-server[all]

# need brew installed first
brew install git shellcheck shfmt fd tmux npm fzf

npm -g install js-beautify


# set up vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# clone dotfiles
git clone git@github.com:sdemura/dotfiles ~/.dotfiles

mkdir -p ~/.config/nvim
ln -sf ~/.dotfiles/nvim/init.vim ~/.config/nvim

nvim +PlugInstall +qa
nvim +UpdateRemotePlugins +qa

# set up tmux
ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
