#!/bin/bash

[[ $EUID -ne 0 ]] && echo "Need to run as root!" && exit 1

install_ripgrep()
{
    hash rg 2>/dev/null
    [[ $? -eq 0 ]] && echo "ripgrep already installed" && return
    f=ripgrep_11.0.1_amd64.deb
    curl -kLO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/$f
    sudo dpkg -i $f
    rm $f
}

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    apt install ${2-$1}
}

install git
install tree
install cscope
install doxygen
install ctags exuberant-ctags
install ag silversearcher-ag
install_ripgrep

grep "^so.*env.*vimrc" ~/.vimrc >/dev/null
[[ $? -ne 0 ]] && echo "so ~/env/vimrc" >> ~/.vimrc

grep ".*~/env/bashrc.*source ~/env/bashrc" ~/.bashrc >/dev/null
[[ $? -ne 0 ]] && echo "[ -f ~/env/bashrc ] && source ~/env/bashrc" >> ~/.bashrc
