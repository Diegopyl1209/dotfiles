
path+=("$HOME/.local/bin") 

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e

fpath=(path/to/zsh-completions/src $fpath)
autoload -U compinit
compinit
zstyle ':completion::complete:*' use-cache 1

alias ls="eza"
alias cat="bat"

eval "$(starship init zsh)"
