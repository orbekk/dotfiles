#!/bin/bash

red='\e[0;31m'
green='\e[0;32m'
none='\e[0m'

cd
# Check that things are in their right places.
if [[ ! -f dotfiles/bin/setup.sh ]]; then
 echo -e "${red}[FAIL]${none} expected to find myself"
 exit 1
fi

# Creates a symlink with target $1 at location $2.
# Does nothing and prints an error message if $2 exists and is not a symlink.
create_symlink() {
  if [[ -e "$2" && ! -h "$2" ]]; then
    echo -e "${red}[WARNING]${none} '$2' exists and is not a symlink. Skipped."
  else
    if ln -sf "$1" "$2"; then
      echo -e "${green}[OK]${none} '$2' → '$1'"
    else
      echo -e "${red}[WARNING] Could not create '$2'"
    fi
  fi
}

create_symlink dotfiles/gitconfig .gitconfig
