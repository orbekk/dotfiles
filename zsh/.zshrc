# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Resources:
# https://github.com/mika/zsh-pony

bindkey -e

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

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# cd to a directory used as a commant
setopt autocd

# commands starting with # are treated as comments
setopt interactivecomments

alias ls="ls --color"
alias e="emacsclient -n"
(( $+commands[exa] )) && alias ls="exa"

if (( $+commands[fzf] )); then
  if (( $+commands[fzf-share] )); then
    # Nixos
    source "$(fzf-share)/completion.zsh"
    source "$(fzf-share)/key-bindings.zsh"
  else
    # Debian
    source /usr/share/doc/fzf/examples/completion.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
fi

if (( $+commands[zoxide] )); then
 eval "$(zoxide init zsh)"
fi

# Issues when typing 'ssh root@' with fast syntax hilighting.
source ~/.zsh/syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# if [[ ! -f ~/.zsh/fast-syntax-highlighting/current_theme.zsh ]]; then
#   fpath+=$HOME/.zsh/fast-syntax-highlighting
#   fast-theme clean
# fi

# allow editing of command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^V" edit-command-line

function get-parent-dir() {
  words=(${(z)LBUFFER})
  if [[ "${words[${#words}]}" = /* ]]; then
    # There is already a path thing here.
    words[${#words}]="${words[${#words}]:h}/"  # Parent directory.
  else
    words=($words $PWD)
  fi
  LBUFFER="${words[@]}"
}
zle -N get-parent-dir
bindkey "^[u" get-parent-dir

source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/p10k.zsh ]] || source ~/.zsh/p10k.zsh
