#!/usr/bin/env bash
set -euo pipefail

STOW="stow -R --no-folding -v"

cd "$(dirname $0)"
git submodule update --init --recursive

$STOW common
$STOW zsh
source $HOME/.zshenv

if which xmonad >/dev/null; then
    $STOW desktop
    touch ~/.Xresources.local
    xrdb -I$HOME -merge ~/.Xresources
    xmonad --recompile
fi

if [[ $# -ge 1 && $1 == "fast" ]]; then
    shift
    exit
fi

if which emacs >/dev/null; then
    $STOW emacs
    if [[ ! -e ~/.emacs.d ]]; then
      git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    fi
    doom sync  # Too slow!
fi

fc-cache || true

tools=(
    rg 
    fzf
    bat
    exa
    most
    emacs
    git
    )
for tool in "${tools[@]}"; do
    if ! type "$tool" &>/dev/null; then
        echo "Missing: $tool"
    fi
done
