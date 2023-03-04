# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# set hist size to something large, as zsh doesn't
# accept empty string like bash does...
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt INTERACTIVECOMMENTS

# https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo

if [ "$TERM_PROGRAM" = "Terminus-Sublime" ]; then
    bindkey "\e[1;3C" forward-word
    bindkey "\e[1;3D" backward-word

    alias ls='lsd -a --color=never'
else
    alias ls='lsd -a'
fi

# tmux options
tabo()  { tmux kill-window -a; }

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

alias ranger='TERM=xterm-256color ranger'
alias rg="rg --hidden -g '!.git'"
alias ely='cd ~/src/gitlab.com/corelight/engineering/elysium'
alias pick='thumbs -u -r | pbcopy'

export PATH=~/bin:$PATH

function theme() {
    case $1 in
        dark)
            yq -i '.import[0] = "~/.dotfiles/alacritty/themes/catppuccin_mocha.yml"' ~/.dotfiles/alacritty/alacritty.yml
            sd -s 'colorscheme catppuccin-latte' 'colorscheme catppuccin-mocha' ~/.dotfiles/nvim/init.lua
            export FZF_DEFAULT_OPTS=" \
                --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
                --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
                --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
            sd '^DEFAULT_THEME=.*' 'DEFAULT_THEME=dark' ~/.zshrc
            ;;

        light)
            yq -i '.import[0] = "~/.dotfiles/alacritty/themes/catppuccin_latte.yml"' ~/.dotfiles/alacritty/alacritty.yml
            sd -s 'colorscheme catppuccin-mocha' 'colorscheme catppuccin-latte' ~/.dotfiles/nvim/init.lua
            export FZF_DEFAULT_OPTS=" \
                --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
                --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
                --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
            sd '^DEFAULT_THEME=.*' 'DEFAULT_THEME=light' ~/.zshrc
            ;;
        *)
            ;;
    esac

}

DEFAULT_THEME=light
theme $DEFAULT_THEME

[[ -f ~/.env.zsh ]] && source ~/.env.zsh
