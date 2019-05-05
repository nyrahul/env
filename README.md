# My Linux env setup

1. Sets up my vim env (default vimrc and vim plugins)
2. Installs required linux pkgs
3. Sets up my bashrc
3. Sets up my gitconfig

## Vimrc
Add following line to default vimrc:

```so ~/env/vimrc```
Added by `setup.sh`.

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

