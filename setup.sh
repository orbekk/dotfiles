#!/usr/bin/env bash
set -euo pipefail

STOW="stow -R --no-folding -v"

cd "$(dirname $0)"
$STOW common
$STOW zsh
source $HOME/.zshenv

if which xmonad >/dev/null; then
    $STOW desktop
    xmonad --recompile
fi

if [[ $# -ge 1 && $1 == "fast" ]]; then
    shift
    exit
fi

if which emacs >/dev/null; then
    $STOW emacs
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    doom sync  # Too slow!
fi
