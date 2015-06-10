#!/bin/bash

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
none='\e[0m'

cd
# Check that things are in their right places.
if [[ ! -f dotfiles/bin/setup.sh ]]; then
 echo -e "${red}[FAIL]${none} expected to find myself"
 exit 1
fi

if ! which git >/dev/null; then
  echo -e "${red}[FAIL]${none} git not installed"
  exit 1
fi

cd ~/dotfiles
git submodule update --init --recursive
git submodule foreach pull

cd
# Creates a symlink with target $1 at location $2.
# Does nothing and prints an error message if $2 exists and is not a symlink.
create_symlink() {
  if [[ -e "$2" && ! -h "$2" ]]; then
    echo -e "${orange}[SKIPPED]${none} '$2' exists and is not a symlink."
    return
  else
    if ln -sf "$1" "$2"; then
      echo -e "${green}[OK]${none} '$2' → '$1'"
    else
      echo -e "${red}[WARNING]${none} could not create '$2'"
    fi
  fi
  if ! diff "$2" "$(dirname $2)/$1"; then
    echo -e "${red}[WARNING]${none} diffs in $2"
  fi
}

create_symlink dotfiles/gitconfig .gitconfig
create_symlink /dev/null .vimrc.local

if [[ "${SHELL}" = *zsh* ]]; then
  create_symlink dotfiles/zshrc .zshrc
else
  echo -e "${orange}[SKIPPED]${none} shell is not zsh :-(."
fi

if which i3 >/dev/null; then
  mkdir -p .i3
  create_symlink ../dotfiles/i3/config .i3/config
else
  echo -e "${orange}[SKIPPED]${none} i3 not installed."
fi

create_symlink dotfiles/vimrc .vimrc
if [[ -e .vim/bundle/Vundle.vim ]]; then
  echo -e "${orange}[SKIPPED]${none} Vundle.vim already installed"
else
  success=1
  mkdir -p .vim/bundle
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    || success=0
  vim +PluginInstall +qall || success=0
  if [[ "$success" == "1" ]]; then
    echo -e "${green}[OK]${none} installed vim plugins"
  else
    echo -e "${red}[WARNING]${none} failed to install vim plugins"
  fi
fi
