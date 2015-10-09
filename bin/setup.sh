#!/bin/bash

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
none='\e[0m'

cd
# Check that things are in their right places.
if [[ ! -f dotfiles/bin/setup.sh ]]; then
 printf "${red}[FAIL]${none} expected to find myself\n"
 exit 1
fi

required_commands=(git basename)
for command in ${required_commands[@]}; do
  if ! which "${command}" >/dev/null; then
    printf "${red}[FAIL]${none} ${command} not installed\n"
    exit 1
  fi
done

cd ~/dotfiles
git submodule update --init --recursive
git submodule foreach pull

cd
# Creates a symlink with target $1 at location $2.
# Does nothing and prints an error message if $2 exists and is not a symlink.
create_symlink() {
  if [[ -e "$2" && ! -h "$2" ]]; then
    printf "${orange}[SKIPPED]${none} '$2' exists and is not a symlink.\n"
    return
  else
    if ln -sf "$1" "$2"; then
      printf "${green}[OK]${none} '$2' → '$1'\n"
    else
      printf "${red}[WARNING]${none} could not create '$2'\n"
    fi
  fi
  if ! diff "$2" "$(dirname $2)/$1"; then
    printf "${red}[WARNING]${none} diffs in $2\n"
  fi
}

create_symlink dotfiles/gitconfig .gitconfig
create_symlink dotfiles/taskrc .taskrc
create_symlink dotfiles/tmux.conf .tmux.conf
create_symlink dotfiles/spacemacs .spacemacs
create_symlink /dev/null .vimrc.local

mkdir -p bin
for binary in dotfiles/bin/*; do
  binary=$(basename "${binary}")
  create_symlink "../dotfiles/bin/${binary}" "bin/${binary}"
done

if [[ "${SHELL}" = *zsh* ]]; then
  create_symlink dotfiles/zshrc .zshrc
else
  printf "${orange}[SKIPPED]${none} shell is not zsh :-(.\n"
fi

mkdir -p .ssh
create_symlink ../dotfiles/ssh/config .ssh/config

if which i3 >/dev/null; then
  mkdir -p .i3
  create_symlink ../dotfiles/i3/config .i3/config
  create_symlink dotfiles/i3status.conf .i3status.conf
else
  printf "${orange}[SKIPPED]${none} i3 not installed.\n"
fi

create_symlink dotfiles/vimrc .vimrc
if [[ -e .vim/bundle/Vundle.vim ]]; then
  printf "${orange}[SKIPPED]${none} Vundle.vim already installed\n"
else
  success=1
  mkdir -p .vim/bundle
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    || success=0
fi
vim +PluginInstall +qall || success=0
if [[ "$success" == "1" ]]; then
  printf "${green}[OK]${none} installed vim plugins\n"
else
  printf "${red}[WARNING]${none} failed to install vim plugins\n"
fi

if which emacs >/dev/null && [[ ! -d .emacs.d ]]; then
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
