#!/bin/bash

sudo apt install build-essential cmake python3-dev bear
[[ $? -ne 0 ]] && echo "cudnot install YCM deps" && exit 2

YCMPATH=~/.vim/bundle/YouCompleteMe
if [ ! -d $YCMPATH ]; then
    git clone https://github.com/Valloric/YouCompleteMe.git $YCMPATH
    [[ $? -ne 0 ]] && echo "cudnot git clone YCM" && rm -rf $YCMPATH && exit 2
    cd $YCMPATH
    git submodule update --init --recursive
    python3 install.py --clang-completer
    cd -
fi

