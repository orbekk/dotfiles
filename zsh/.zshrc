# Resources:
# https://github.com/mika/zsh-pony

bindkey -e

fpath+=$HOME/.zsh/pure

autoload -Uz compinit; compinit
autoload -Uz promptinit; promptinit

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Don't skip over symbols, e.g., when deleting a word from a path.
WORDCHARS=''

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt append_history share_history histignorealldups

# cd to a directory used as a commant
setopt autocd

PURE_GIT_PULL=0
PURE_GIT_UNTRACKED_DIRTY=0
prompt pure

alias ls="ls --color"

source ~/.zshrc.local
