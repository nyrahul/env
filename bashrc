GREEN="\[\033[0;32m\]"	# 0=Normal, 1=Bold, 2=Faint, 3=Italics, 4=Underline
ORANGE="\[\033[33m\]"
BLUE="\[\033[34m\]"
CYAN="\[\033[36m\]"
NC="\[\033[00m\]"

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

	status=""
	modcnt=`git status -s | grep " *M "  | wc -l`
	newcnt=`git status -s | grep " *?? " | wc -l`
	delcnt=`git status -s | grep " *D "  | wc -l`
	[[ $modcnt -eq 0 ]] && [[ $newcnt -eq 0 ]] && [[ "$ahead" == "" ]] && return
	[[ $modcnt -ne 0 ]] && status="`echo -e "\U0001f4dd"`${modcnt}"
	[[ $newcnt -ne 0 ]] && status="$status `echo -e '\U0002795'`$newcnt"
	[[ $delcnt -ne 0 ]] && status="$status `echo -e '\U0001f6ab'`$delcnt"
	#[[ $delcnt -ne 0 ]] && status="$status `echo -e '\U0001FA93'`$delcnt"
	[[ $ahead != "" ]] && status="$status `echo -e '\U0001f4e4'`$ahead"
	status=`echo $status | xargs` # trim whitespaces
	echo -en "($status)"
}

k8scluster_name()
{
    str=`kubectl config current-context 2>/dev/null`
	[[ $? -ne 0 ]] && return
    [[ "$str" != "" ]] && echo "$CYAN[$str]$NC " && return
}

# for bash, customize the prompt for git/k8s details. These are already available for zsh/p10k.
[[ "$(ps -q $$ -o comm=)" == "bash" ]] && export PS1="$(k8scluster_name)\u@\h:$GREEN\w$CYAN$(parse_git_branch)$NC$ORANGE$(parse_git_status)$NC\$ "

export LC_ALL="en_US.UTF-8"

# Mutt needs this
export EDITOR=vim
export PATH=$PATH:~/env/rtscripts
alias xdg-open="xdg-open 2>&1 >/dev/null"

kubectl_play()
{
	[[ "$(which kubectl)" == "" ]] && return
	alias k=kubectl
	alias wkp="watch kubectl get pod -A"
	alias wks="watch kubectl get svc -A"
	alias wkps="watch kubectl get pod,svc -A"
	alias kgpa="kubectl get pod -A"
	alias kgps="kubectl get svc -A"
	source <(kubectl completion bash)
	complete -F __start_kubectl k
}

kubectl_play
alias watch="watch "
export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin
