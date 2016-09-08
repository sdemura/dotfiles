#!/bin/bash

# bash prompt
#PS1='\u@\h:\w\$$(parse_git_branch) '
PS1='\W\$$(parse_git_branch) '

# needed for iTerm2
if [ "$ITERM_SESSION_ID"  ]; then
    export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"'
fi

# GREP COLORS
export GREP_OPTIONS='--color=always'
export GREP_COLOR='1;35;40'

# alias python3
alias p3="python3"
# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Personal stuff
export API_DIR='/Users/sean/Code/go/src/github.com/apcera/apcera-tools/users/sean/apcera_api_demo'
export PYAPC='/Users/sean/Code/go/src/github.com/apcera/apcera-tools/users/sean/pyapc'
export PROJECT_HOME=~/python/
export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python3'
export APCSRC=/Users/sean/Code/go/src/github.com/apcera
export ROCKSALT=$APCSRC/rocksalt
export ROCKTOP=$APCSRC/rocksalt-top
export ROCKWIN=$APCSRC/rocksalt-win
export BOXCUTTER=/Users/sean/Code/go/src/github.com/boxcutter
export GITHUB=/Users/sean/Code/go/src/github.com
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export SALTGPG=~/.saltgpg
#PERSONAL TOOLS
export PATH="$PATH:$HOME/.tools"
export TERMBG=dark


#HCOSM STUFF
export SYNC_APCERA_SOURCE=false
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export GOPATH="$HOME/Code/go"
export BUILDROOT="$HOME/Code/go"
export PATH="$PATH:BUILDROOT/bin"
export PKG_CONFIG_PATH=$BUILDROOT/bin/openssl/lib/pkgconfig:$PKG_CONFIG_PATH
export VAGRANT_DIR=$BUILDROOT/src/github.com/apcera/continuum-vagrant
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:/Users/sean/bin
export PATH=$PATH:/Users/sean/Code/go/src/github.com/apcera/continuum-vagrant/scripts
export PATH=$PATH:/$GOPATH/bin
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH=$PATH:/Users/sean/ops/bin

# Show git in PS1
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/ '
}

# make PS1 shorter
function shorten_ps1 {
    unset PS1
    PS1='\W\$$(parse_git_branch) '
}

# make PS1 longer
function lengthen_ps1 {
    unset PS1
    PS1='\u@\h:\w\$$(parse_git_branch) '
}

# set up tab titles on terminals
function title {
    if [ "$1" ]; then
        unset PROMPT_COMMAND
        echo -n -e "\033]0;${*}\007"
    else
        export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
    fi
}

# Initialization for FDK command line tools.Mon Feb 29 09:41:46 2016
FDK_EXE="/Users/sean/bin/FDK/Tools/osx"
PATH=${PATH}:"/Users/sean/bin/FDK/Tools/osx"
export PATH
export FDK_EXE

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
