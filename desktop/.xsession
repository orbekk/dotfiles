#!/usr/bin/env bash
set -euo pipefail

SETUP_MARKER=$HOME/.local/share/__kj.dotfiles__
if [[ ! -e "$SETUP_MARKER" ]]; then
    echo running setup
    urxvt -e sh -c "$HOME/dotfiles/setup.sh; zsh"
    touch "$SETUP_MARKER"
fi

export TERMINAL=urxvt
xrdb -merge $HOME/.Xresources
setxkbmap us -variant dvorak -option compose:ralt -option caps:ctrl_modifier
xsetroot -solid "#2A3462"
pasystray &
xss-lock -- /usr/bin/env xscreensaver-command --lock &
xset -b
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 100 --widthtype pixel --transparent true --alpha 0 --tint 0x000000 --height 18 &
[[ -f /etc/nixos/configuration.nix ]] || \
  redshift -l 40:-70 -r -t 5500:3700 &
exec xmonad


