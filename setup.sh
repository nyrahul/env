#!/bin/bash

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    sudo apt -y install ${2-$1}
}

install_ripgrep()
{
    hash rg 2>/dev/null
    [[ $? -eq 0 ]] && echo "ripgrep already installed" && return
    f=ripgrep_11.0.1_amd64.deb
    curl -kLO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/$f
    sudo dpkg -i $f
    rm $f
}

install curl
install ctags exuberant-ctags
install vim
install cscope
install doxygen
install highlight
install fonts-powerline
install tmux
install tree
install cloc
install_ripgrep
install ifconfig net-tools
install ctags exuberant-ctags
install ag silversearcher-ag

vundle_install()
{
	[[ -d $1 ]] && return
	git clone $2 $1
	[[ $? -ne 0 ]] && echo "cudnot install $1!" && rm -rf $1 && exit 2
}

mkdir -p ~/.vim/autoload ~/.vim/bundle 2>/dev/null

grep "^so.*env.*vimrc" ~/.vimrc >/dev/null
[[ $? -ne 0 ]] && echo "so ~/env/vimrc" >> ~/.vimrc

grep ".*~/env/bashrc.*source ~/env/bashrc" ~/.bashrc >/dev/null
[[ $? -ne 0 ]] && echo "[ -f ~/env/bashrc ] && source ~/env/bashrc" >> ~/.bashrc

touch ~/.tmux.conf
grep "source-file.*~/env/tmux.conf" ~/.tmux.conf >/dev/null
[[ $? -ne 0 ]] && echo "source-file ~/env/tmux.conf" >> ~/.tmux.conf

PATHOGEN=~/.vim/autoload/pathogen.vim
if [ ! -f $PATHOGEN ]; then
    curl -kLo $PATHOGEN https://tpo.pe/pathogen.vim
    [[ ! -f $PATHOGEN ]] && echo "cudnot install pathogen" && exit 2
fi

vundle_install ~/.vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git
vundle_install ~/.vim/bundle/vim-better-whitespace git://github.com/ntpeters/vim-better-whitespace.git

PLUGVIM=~/.vim/autoload/plug.vim
if [ ! -f $PLUGVIM ]; then
    curl -kfLo $PLUGVIM --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    [[ ! -f "$PLUGVIM" ]] && echo "Could not download plug.vim!" && exit 2

    # Install fzf and fzf.vim using vim.plug
    vim -c ":PlugInstall" -c ":qa"
fi

./ycm_install.sh

if [ "$1" != "" ]; then
    echo "Installing packages. Need root permissions."
    sudo ./setup_pkgs.sh
fi

[[ ! -f ~/.gitconfig ]] && cp ~/env/.gitconfig ~/.

echo "NOTE: Logout and login the terminal again to take effect."
