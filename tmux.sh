#!/bin/bash

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    sudo apt -y install ${2-$1}
}

install git
install tmux
git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
curl https://raw.githubusercontent.com/nyrahul/env/master/tmux.conf.local -o $HOME/
