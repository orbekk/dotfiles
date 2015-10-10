# :)
# ulimit -v 4194304 # 4G
# ulimit -u 1024

if [[ -f  $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

# Don't upgrade oh-my-zsh automatically.
DISABLE_AUTO_UPDATE="true"

source $HOME/dotfiles/zgen/zgen.zsh
# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"
  zgen oh-my-zsh
  # plugins
  # zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/ssh-agent
  zgen oh-my-zsh plugins/gpg-agent
  zgen oh-my-zsh plugins/sudo
  zgen oh-my-zsh plugins/history
  zgen oh-my-zsh plugins/jump
  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/taskwarrior
  zgen load zsh-users/zsh-syntax-highlighting
  # completions
  zgen load zsh-users/zsh-completions src
  # theme
  # zgen oh-my-zsh themes/frisk
  zgen load ehamberg/pure
  # save all to init script
  zgen save
fi

setopt extendedglob
LANG=en_US.UTF-8
HISTSIZE=1000000
SAVEHIST=1000000

if (( $+commands[ack-grep] )) ; then
  alias ack=ack-grep
fi

# Emacs-like editor
bindkey -e
export WORDCHARS=''

# Dvorak
setopt DVORAK

# alias ls="ls --color"
if which gvim >/dev/null; then
  alias vi="gvim --remote"
  alias e="emacsclient -n"
fi
alias ff="fileutil --gfs_user=gfp-reporting"
alias diff=colordiff
alias j=jump

export EDITOR=vim
export PAGER=less
export TZ='America/New_York'
export PATH=$HOME/bin:$PATH

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
