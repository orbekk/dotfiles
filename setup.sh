#!/usr/bin/env bash
set -euo pipefail

STOW="stow -R --no-folding -v"

cd "$(dirname $0)"
$STOW -R zsh
source $HOME/.zshenv

$STOW -R Xresources

if which emacs >/dev/null; then
  $STOW -R emacs
  # doom sync  # Too slow!
fi

if which xmonad >/dev/null; then
    $STOW xmonad
    xmonad --recompile
fi
