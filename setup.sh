#!/bin/bash

mkdir -p ~/.vim/autoload 2>/dev/null

grep "^so.*env.*vimrc" ~/.vimrc >/dev/null
[[ $? -ne 0 ]] && echo "so ~/env/vimrc" >> ~/.vimrc

grep ".*~/env/bashrc.*source ~/env/bashrc" ~/.bashrc >/dev/null
[[ $? -ne 0 ]] && echo "[ -f ~/env/bashrc ] && source ~/env/bashrc" >> ~/.bashrc

PLUGVIM=~/.vim/autoload/plug.vim
if [ ! -f $PLUGVIM ]; then
    curl -kfLo $PLUGVIM --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    [[ ! -f "$PLUGVIM" ]] && echo "Could not download plug.vim!" && exit 2

    # Install fzf and fzf.vim using vim.plug
    vim -c ":PlugInstall" -c ":qa"
fi

echo "Installing packages. Need root permissions."
sudo ./setup_pkgs.sh

echo "NOTE: Logout and login the terminal again to take effect."
