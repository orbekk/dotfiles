#!/usr/bin/env bash
set -euo pipefail

SETUP_MARKER=$HOME/.local/share/__kj.dotfiles__
if [[ ! -e "$SETUP_MARKER" ]]; then
    echo running setup
    urxvt -e sh -c "$HOME/dotfiles/setup.sh"
    touch "$SETUP_MARKER"
fi

export TERMINAL=urxvt
xrdb -merge $HOME/.Xresources
setxkbmap us -variant dvorak -option compose:ralt -option caps:ctrl_modifier
xsetroot -solid "#2A3462"
pasystray &
xss-lock -- /usr/bin/env xscreensaver-command --lock &
xset -b
dzen2 -dock -x 0 -h 24 -e 'onstart=lower' -bg '#252526' -p &
conky | dzen2 -dock -geometry 800x24-950+0 -expand left -fn "WenQuanYi Micro Hei-16" -ta r -bg '#252526' -fg '#f4f4f4' &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 100 --widthtype pixel --transparent true --height 24 --tint 0x252526  --alpha 0 &

[[ -f /etc/nixos/configuration.nix ]] || \
  redshift -l 40:-70 -r -t 5500:3700 &

nm-applet --no-agent &

if which autorandr >/dev/null; then
  autorandr --change
fi

exec xmonad
