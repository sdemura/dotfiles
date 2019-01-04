#!/bin/bash
set -ex

yum update -y
yum install -y sudo
yum install -y vim
yum install -y epel-release
yum groupinstall -y 'Development Tools'

rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco

cat <<EOF >/etc/yum.repos.d/wandisco-git.repo
[wandisco-git]
name=Wandisco GIT Repository
baseurl=http://opensource.wandisco.com/centos/7/git/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
EOF

yum install -y git \
    wget \
    ncurses-devel \
    libicu-devel \
    cmake \
    fuse \
    python-devel \
    python2-pip \
    python36 \
    python36-devel \
    python36-setuptools \
    virtualenv
easy_install-3.6 pip

# install deps
yum -y install gcc kernel-devel make ncurses-devel

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
# curl -OL https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
# tar -xvzf libevent-2.1.8-stable.tar.gz
# cd libevent-2.1.8-stable
# ./configure --prefix=/usr/local
# make
# sudo make install
# cd ..
#
# # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
# curl -OL https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
# tar -xvzf tmux-2.7.tar.gz
# cd tmux-2.7
# LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
# make
# sudo make install
# cd ..
#
# wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz
# tar zvfx boost_1_67_0.tar.gz
# cd boost_1_67_0
# sudo ./bootstrap.sh --prefix=/opt/boost
# sudo ./b2 install --prefix=/opt/boost --with=all
# cd ..

ln -sf $(pwd)/bashrc-centos7 ~/.bashrc # pragma: whitelist secret
# source ~/.bashrc

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo pip install neovim
sudo $(which pip3) install neovim

mkdir -p ~/bin
pushd ~/bin
wget https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
ln -sf $(pwd)/squashfs-root/usr/bin/nvim ~/bin/nvim # pragma: whitelist secret
popd
~/bin/nvim +PlugInstall +qa

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
sudo yum install -y ripgrep
sudo yum install -y mysql
sudo yum install -y jq

mkdir -p /usr/local/go
cd /usr/local/go
wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
tar zvfx go1*.tar.gz
ln -sf /usr/local/go/bin/go /usr/local/bin/go
cd -

git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure --prefix=/usr/local
make
sudo make install
cd ..

# ln -sf $(realpath rc) ~/.ssh/rc

# sudo rm -rf ctags
# sudo rm -rf tmux-2.7
# sudo rm -rf libevent-2.1.8-stable
# sudo rm -rf boost_1_67_0
