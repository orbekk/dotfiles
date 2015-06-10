# :)
# ulimit -v 4194304 # 4G
# ulimit -u 1024

source $HOME/dotfiles/zgen/zgen.zsh
# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"
  zgen oh-my-zsh
  # plugins
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/sudo
  zgen oh-my-zsh plugins/history
  zgen oh-my-zsh plugins/autojump
  zgen oh-my-zsh plugins/command-not-found
  zgen load zsh-users/zsh-syntax-highlighting
  # completions
  zgen load zsh-users/zsh-completions src
  # theme
  # zgen oh-my-zsh themes/frisk
  zgen load ehamberg/pure
  # save all to init script
  zgen save
fi

# Emacs-like editor
bindkey -e
export WORDCHARS=''

# Dvorak
setopt DVORAK

alias ls="ls --color"
if which gvim >/dev/null; then
  alias vi="gvim --remote"
fi
alias ff="fileutil --gfs_user=gfp-reporting"
alias diff=colordiff

if [[ -f  ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

export EDITOR=vim
export PAGER=less
export TZ='America/New_York'

# allow editing of command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^V" edit-command-line
