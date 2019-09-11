#!/bin/bash

set -exo pipefail

if [[ $(uname) == 'Linux' ]]; then
    sudo apt-get install -y \
        build-essential \
        curl \
        fd-find \
        fzf \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        neovim \
        python-openssl \
        ripgrep \
        shellcheck \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        zsh
else
    # use zsh from macos
    brew install --force readline xz neovim ripgrep fzf fd shellcheck coreutils
fi

if [[ ! -d ~/.pyenv ]]; then
    curl https://pyenv.run | bash
fi

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

PYTHON_2=2.7.16
PYTHON_3=3.6.9

pyenv install -s $PYTHON_2
pyenv install -s $PYTHON_3

pyenv virtualenv -f $PYTHON_3 neovim-py3
pyenv virtualenv -f $PYTHON_2 neovim-py2

pyenv global $PYTHON_2 $PYTHON_3

pyenv activate neovim-py3
pip3 install black jedi pynvim neovim pylint
pyenv deactivate

pyenv activate neovim-py2
pip install pynvim neovim
pyenv deactivate

if [[ ! -d "$HOME/.oh-my-zsh/" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    ln -sf "$(realpath zshenv)" ~/.zshenv
    ln -sf "$(realpath zshrc)" ~/.zshrc
fi

mkdir -p ~/.config/nvim
ln -sf "$(realpath init.vim)" ~/.config/nvim/init.vim
nvim +PlugInstall +qa
