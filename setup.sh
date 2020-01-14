#!/bin/bash

set -exo pipefail

if [[ $(uname) == 'Linux' ]]; then
    if grep -ie "Debian|Ubuntu" /etc/os-release; then
        sudo apt-get install -y \
            build-essential \
            curl \
            fd-find \
            fzf \
            fuse \
            git \
            httpie \
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
            python-openssl \
            ripgrep \
            shellcheck \
            squashfuse \
            tk-dev \
            tmux \
            wget \
            xz-utils \
            zlib1g-dev \
            zsh
    else
        sudo yum install -y epel-release
        sudo yum groupinstall -y 'Development Tools'
        sudo yum install -y \
            zlib-devel readline-devel \
            ncurses-devel \
            openssl-devel \
            xz-devel \
            sqlite-devel \
            tk-devel \
            llvm \
            llvm-devel \
            curl wget fuse \
            util-linux-user \
            zsh

    fi

    if ! command -v nvim; then
        wget https://github.com/neovim/neovim/releases/download/v0.4.2/nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
        sudo chmod +x /usr/local/bin/nvim
    fi
else
    # use zsh from macos
    brew reinstall readline xz neovim ripgrep fzf fd shellcheck coreutils httpie git
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
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

ln -sf "$(realpath sean.zsh-theme)" ~/.oh-my-zsh/custom/themes/sean.zsh-theme

mkdir -p ~/.config/nvim
ln -sf "$(realpath init.vim)" ~/.config/nvim/init.vim
nvim +PlugInstall +qa

mkdir -p ~/.tmux/plugins
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf "$(realpath tmux.conf)" ~/.tmux.conf
