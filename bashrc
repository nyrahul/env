GREEN="\[\033[32m\]"
ORANGE="\[\033[33m\]"
CYAN="\[\033[36m\]"
NC="\[\033[00m\]"

#parse_git_branch() {
#    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#}

parse_git_branch() {
	git branch 2>/dev/null >/dev/null
	[[ $? -ne 0 ]] && return
    branch=`git branch --show-current`
	echo " [$branch]"
}

parse_git_status() {
	git branch 2>/dev/null >/dev/null
	[[ $? -ne 0 ]] && return

	ahead=`git status | grep "Your branch is ahead" | awk '{ print $8 }'`
	# Your branch is ahead of 'origin/master' by 2 commits.

	modcnt=`git status -s | grep " *M "  | wc -l`
	newcnt=`git status -s | grep " *?? " | wc -l`
	[[ $modcnt -eq 0 ]] && [[ $newcnt -eq 0 ]] && [[ "$ahead" == "" ]] && return
	[[ $modcnt -ne 0 ]] && status="!${modcnt}"
	[[ $newcnt -ne 0 ]] && status="?$status$newcnt"
	[[ $ahead != "" ]] && status="^$status$ahead"
	echo -en "($status)"
}

netns_name() {
    str=`ip netns identify $$`
    [[ "$str" != "" ]] && echo "\033[1;35m[$str]\033[0m " && return
}
export PS1="$(netns_name)\u@\h:$GREEN\w$CYAN\$(parse_git_branch)$ORANGE\$(parse_git_status)$NC\$ "

export LC_ALL="en_US.UTF-8"

# WARNING: This may not be the suitable bet for everyone!
#[[ $TERM != "screen" ]] && exec tmux

# Mutt needs this
export EDITOR=vim
export PATH=/usr/lib/ccache:$PATH:~/env/rtscripts
alias xdg-open="xdg-open 2>&1 >/dev/null"
alias k=kubectl
alias wkp="watch kubectl get pod -A"
alias wks="watch kubectl get svc -A"
alias wkps="watch kubectl get pod,svc -A"
alias kgpa="kubectl get pod -A"
alias kgps="kubectl get svc -A"
alias watch="watch "
complete -F __start_kubectl k
export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin
