#!/bin/bash

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    hash apt 2>/dev/null
	if [ $? -eq 0 ]; then
		sudo apt -y install ${2-$1}
	else
	    sudo dnf install ${2-$1}
	fi
}

install_kubectx()
{
    hash kubectx 2>/dev/null
    [[ $? -eq 0 ]] && echo "kubectx already installed" && return
	git clone https://github.com/ahmetb/kubectx /tmp/kubectx
	sudo ln -s /tmp/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -s /tmp/kubectx/kubenx /usr/local/bin/kubens
	rm -rf /tmp/kubectx
}

install_kubectl()
{
    hash kubectl 2>/dev/null
    [[ $? -eq 0 ]] && echo "kubectl already installed" && return
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl &&	sudo mv kubectl /usr/local/bin/
    rm kubectl
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

install_nvim()
{
	if [ -f /usr/local/bin/nvim ]; then
		echo "Neovim is already installed"
		return
	fi
	install fuse2fs fuse
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod +x nvim.appimage
	sudo mv nvim.appimage /usr/local/bin/nvim

	if [ ! -f $HOME/.config/nvim/init.vim ]; then
		mkdir -p $HOME/.config/nvim
		cp init.vim $HOME/.config/nvim/
	fi
}

sudo apt update
install git
[[ ! -d "$HOME/env" ]] && git clone https://github.com/nyrahul/env.git && cd $HOME/env

install curl
install ctags exuberant-ctags
install vim
install_nvim
install fonts-powerline
install_ripgrep
install_kubectl
install_kubectx
install ag silversearcher-ag

bundle_install()
{
	repo=`basename $1 .git`
	dstpath=~/.vim/bundle/$repo
	[[ -d $dstpath ]] && return
	git clone $1 $dstpath
	[[ $? -ne 0 ]] && echo "cudnot install $dstpath!" && rm -rf $dstpath && exit 2
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

bundle_install https://github.com/scrooloose/nerdtree.git
#bundle_install https://github.com/ntpeters/vim-better-whitespace.git
bundle_install https://github.com/VundleVim/Vundle.vim.git

PLUGVIM=~/.vim/autoload/plug.vim
if [ ! -f $PLUGVIM ]; then
    curl -kfLo $PLUGVIM --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    [[ ! -f "$PLUGVIM" ]] && echo "Could not download plug.vim!" && exit 2

    # Install fzf and fzf.vim using vim.plug
    vim -c ":PlugInstall" -c ":qa"
fi
vim -c ":PluginInstall" -c ":qa"

INDENTLINE=~/.vim/pack/vendor/start/indentLine
if [ ! -d $INDENTLINE ]; then
	git clone --depth=1 https://github.com/Yggdroot/indentLine.git $INDENTLINE
fi

./ycm_install.sh

if [ "$1" != "" ]; then
    echo "Installing packages. Need root permissions."
    sudo ./setup_pkgs.sh
fi

[[ ! -f ~/.gitconfig ]] && cp ~/env/.gitconfig ~/.

echo "NOTE: Logout and login the terminal again to take effect."
