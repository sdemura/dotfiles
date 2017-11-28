#!/bin/bash

# Show git in PS1
function parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/ '
}

# make PS1 shorter
function shorten_ps1() {
	unset PS1
	# PS1='\W\$$(parse_git_branch) '
	PS1='\[\033[1;34m\]\W\[\033[0m\]\[\033[1;32m\]$(parse_git_branch)\[\033[0m\]\$ '
}

# make PS1 longer
function lengthen_ps1() {
	unset PS1
	#PS1='\u@\h:\w\$$(parse_git_branch) '
	PS1='\[\033[1;36m\]\u@\h:\[\033[0m\]\[\033[1;34m\]\W\[\033[0m\]\[\033[1;32m\]$(parse_git_branch)\[\033[0m\]\$ '

}

# set up tab titles on terminals
function title() {
	if [ "$1" ]; then
		unset PROMPT_COMMAND
		echo -n -e "\033]0;${*}\007"
	else
		export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
	fi
}

# needed for iTerm2
if [ "$ITERM_SESSION_ID" ]; then
	export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"'
fi

# GREP COLORS
export GREP_OPTIONS='--color=always'
export GREP_COLOR='1;35;40'

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

#HCOSM STUFF
# export PATH="/usr/local/bin:$PATH"
# export PATH="/usr/local/sbin:$PATH"
export GOPATH=~/go
export PATH=$PATH:/Users/sean/bin
export PATH=$PATH:/Users/sean/ops/bin
export PATH=$PATH:$GOPATH/bin

export APCSRC=$GOPATH/src/github.com/apcera
export GITHUB=/Users/sean/Code/go/src/github.com
export ROCKSALT=$APCSRC/rocksalt
export ROCKTOP=$APCSRC/rocksalt-top
export SALTGPG=~/.saltgpg
export VAGRANT_DEFAULT_PROVIDER=virtualbox

# GPG APCERA RELEASE KEY
export CNTMP_PRIV_KEY_PASS=kMihczEw59J24UHUwWaq

# Set short PS1 as default
shorten_ps1

# LS Colors
alias ls='ls -GFh'

# Configure rbenv
eval "$(rbenv init -)"

alias ai="apcera-install"
