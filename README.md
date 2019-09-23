# My Linux env setup

1. Sets up my vim env (default vimrc and vim plugins)
2. Installs required linux packages
3. Sets up my bashrc
4. Sets up my gitconfig
5. Script to set default TCP Congestion control algorithm to BBR (not enabled by default)

## Vimrc
Add following line to default vimrc:

```so ~/env/vimrc```

Added by `setup.sh`.

vim plugins used:
1. [fzf](https://github.com/junegunn/fzf.vim)
2. [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
3. [NERDTree](https://github.com/scrooloose/nerdtree)
4. [DoxygenToolkit](https://github.com/vim-scripts/DoxygenToolkit.vim)
5. [taglist](https://www.vim.org/scripts/script.php?script_id=273)
6. [lightline](https://github.com/itchyny/lightline.vim)
7. [Pathogen](https://github.com/tpope/vim-pathogen)
8. [vim-plug](https://github.com/junegunn/vim-plug)

_Not in the order of preference!_

## Bashrc
Add following line to default bashrc:

```[ -f ~/env/bashrc ] && source ~/env/bashrc```

Added by `setup.sh`.

## Gitconfig
Add following line to default .gitconfig:
```
[include]
	path = ~/env/.gitconfig
```
Not added by `setup.sh`.

## tmux config
Configures mouse support, disables tmux statusline etc.

## Screenrc (deprecated now)
I have a screenrc which I used for a long time but is now deprecated and not maintained (in favor of tmux).
