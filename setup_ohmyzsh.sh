#!/bin/bash

[[ $UID -eq 0 ]] && echo "do not run it with root" && exit

install()
{
    hash $1 2>/dev/null
    [[ $? -eq 0 ]] && echo "${2-$1} already installed" && return
    sudo apt -y install ${2-$1}
}

install zsh
install curl
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
if [ "$ZSH_CUSTOM" == "" ]; then
    ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
fi
if [ "$ZSH_CUSTOM" != "" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    cp ./zshrc ~/.zshrc
    cp ./p10k.zsh ~/.p10k.zsh
else
    echo "login using zsh"
fi


