
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# The next line updates PATH for the Google Cloud SDK.
#source '/Users/sean/google-cloud-sdk/path.bash.inc'

# The next line enables bash completion for gcloud.
#source '/Users/sean/google-cloud-sdk/completion.bash.inc'
# Initialization for FDK command line tools.Mon Feb 29 09:41:46 2016
FDK_EXE="/Users/sean/bin/FDK/Tools/osx"
PATH=${PATH}:"/Users/sean/bin/FDK/Tools/osx"
export PATH
export FDK_EXE

#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
