#!/bin/bash

mkdir -p ~/.vim/autoload ~/.vim/bundle 2>/dev/null

grep "^so.*env.*vimrc" ~/.vimrc >/dev/null
[[ $? -ne 0 ]] && echo "so ~/env/vimrc" >> ~/.vimrc

grep ".*~/env/bashrc.*source ~/env/bashrc" ~/.bashrc >/dev/null
[[ $? -ne 0 ]] && echo "[ -f ~/env/bashrc ] && source ~/env/bashrc" >> ~/.bashrc

PATHOGEN=~/.vim/autoload/pathogen.vim
if [ ! -f $PATHOGEN ]; then
    curl -kLo $PATHOGEN https://tpo.pe/pathogen.vim
    [[ ! -f $PATHOGEN ]] && echo "cudnot install pathogen" && exit 2
fi

NERDTREE=~/.vim/bundle/nerdtree
if [ ! -d $NERDTREE ]; then
    git clone https://github.com/scrooloose/nerdtree.git $NERDTREE
    [[ $? -ne 0 ]] && echo "cudnot install nerdtree!" && rm -rf $NERDTREE && exit 2
fi

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
