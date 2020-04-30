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
    apt -y install ${2-$1}
}

install git
install terminator
install gnome-tweaks gnome-tweak-tool
install tree
install cscope
install doxygen
install highlight
install tmux
install gimp
install vlc
install cloc
install flameshot
install ifconfig net-tools
install ctags exuberant-ctags
install ag silversearcher-ag
install_ripgrep

# Needed for gromit-mpx
install libindicator3-dev
install gir1.2-appindicator3-0.1
