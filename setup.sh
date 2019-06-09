#!/bin/bash

grep "^so.*env.*vimrc" ~/.vimrc >/dev/null
[[ $? -ne 0 ]] && echo "so ~/env/vimrc" >> ~/.vimrc

grep ".*~/env/bashrc.*source ~/env/bashrc" ~/.bashrc >/dev/null
[[ $? -ne 0 ]] && echo "[ -f ~/env/bashrc ] && source ~/env/bashrc" >> ~/.bashrc

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -kfLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "Installing packages. Need root permissions."
sudo ./setup_pkgs.sh
