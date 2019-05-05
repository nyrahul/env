#!/bin/bash

apt install git
apt install tree # for directory tree and pstree
apt install cscope
apt install exuberant-ctags
apt install silversearcher-ag

install_ripgrep()
{
    curl -kLO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
    sudo dpkg -i ripgrep_11.0.1_amd64.deb
    rm ripgrep_11.0.1_amd64.deb
}

install_ripgrep


