#!/usr/bin/env bash
set -euo pipefail

SETUP_MARKER=$HOME/.local/share/__kj.dotfiles__
if [[ ! -e "$SETUP_MARKER" ]]; then
    echo running setup
    urxvt -e sh -c "$HOME/dotfiles/setup.sh; zsh"
    touch "$SETUP_MARKER"
fi
