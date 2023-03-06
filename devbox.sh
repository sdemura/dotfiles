#!/usr/bin/env bash

set -exo pipefail

sudo curl -Lo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod +x /usr/local/bin/nvim

if [[ ! -d ~/.dotfiles ]]; then
    git clone git@github.com:sdemura/dotfiles.git ~/.dotfiles
    ln -sf ~/.dotfiles/nvim ~/.config/nvim
fi

sudo snap install task --classic
sudo apt install -y awscli jq git-lfs nodejs npm

sudo curl -sSLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.30.6/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq

sudo rm -rf /usr/local/go
sudo curl -fsSLO "https://go.dev/dl/go1.19.5.linux-amd64.tar.gz"
sudo tar zfx go1.19.5.linux-amd64.tar.gz -C /usr/local
sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
sudo rm -f go1.19.5.linux-amd64.tar.gz

sudo apt-get update
sudo apt-get install -y \
	ca-certificates \
	curl \
	gnupg \
	lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get install -y docker-ce docker-ce-cli

sudo apt-get install -y fd-find
sudo ln -s /usr/bin/fdfind /usr/bin/fd

curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin

sudo snap install --classic ripgrep
