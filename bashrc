
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
netns_name() {
    str=`ip netns identify $$`
    [[ "$str" != "" ]] && echo "\033[1;35m[$str]\033[0m " && return
}
export PS1="$(netns_name)\u@\h:\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\$ "

export LC_ALL="en_US.UTF-8"

# WARNING: This may not be the suitable bet for everyone!
#[[ $TERM != "screen" ]] && exec tmux

# Mutt needs this
export EDITOR=vim
