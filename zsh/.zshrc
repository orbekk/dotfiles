# Resources:
# https://github.com/mika/zsh-pony

bindkey -e

fpath+=$HOME/.zsh/pure

autoload -Uz compinit; compinit
autoload -Uz promptinit; promptinit

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

setopt append_history share_history histignorealldups

PURE_GIT_PULL=0
PURE_GIT_UNTRACKED_DIRTY=0

prompt pure
