#!/bin/bash

set -ex

mkdir -p ~/.config/nvim
ln -sf $(realpath init.vim) ~/.config/nvim/init.vim

ln -sf $(realpath zshenv) ~/.zshenv
ln -sf $(realpath zshrc) ~/.zshrc
