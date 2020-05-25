#!/bin/bash

[[ $EUID -ne 0 ]] && echo "Need to run as root!" && exit 1

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    apt -y install ${2-$1}
}

install terminator
install gnome-tweaks gnome-tweak-tool
install gimp
install vlc
install flameshot
install mypaint

# Needed for gromit-mpx
install libindicator3-dev
install gir1.2-appindicator3-0.1
