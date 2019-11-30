#!/bin/bash

[[ $EUID -ne 0 ]] && echo "Need to run as root!" && exit 1

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    apt -y install ${2-$1}
}

install zsh
install curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

