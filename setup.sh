#!/bin/bash

set -ex

mkdir -p ~/.config/nvim
ln -sf $(realpath init.vim) ~/.config/nvim/init.vim

ln -sf $(realpath zshenv) ~/.zshenv
ln -sf $(realpath zshrc) ~/.zshrc

if [[ $(uname) == 'Linux' ]]; then
    curl https://pyenv.run | bash
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
else
    brew install pyenv
    brew install pyenv-virtualenv
fi

pyenv install 2.7.16
pyenv install 3.6.9

pyenv virtualenv 3.6.9 neovim-py3
pyenv virtualenv 2.7.16 neovim-py2

pyenv global 2.7.16 3.6.9

pyenv activate neovim-py3
pip3 install black jedi pynvim neovim pylint
pyenv deactivate

pyenv activate neovim-py2
pip install pynvim neovim
pyenv deactivate

