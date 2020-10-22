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

(( $+commands[exa] )) && alias ls="exa"
(( $+commands[bat] )) && alias cat="bat"
# if (( $+commands[most] )); then
#     alias less="most"
#     export PAGER="most"
# fi
if (( $+commands[fzf] )); then
  if (( $+commands[fzf-share] )); then
    # Nixos
    source "$(fzf-share)/completion.zsh"
    source "$(fzf-share)/key-bindings.zsh"
  else
    echo "Configure fzf!"
  fi
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
if [[ ! -f ~/.zsh/fast-syntax-highlighting/current_theme.zsh ]]; then
  fpath+=$HOME/.zsh/fast-syntax-highlighting
  fast-theme clean
fi

source ~/.zshrc.local
