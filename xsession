#!/usr/bin/env bash

xrdb -merge $HOME/.Xresources
setxkbmap us -variant dvorak -option compose:ralt -option caps:ctrl_modifier
$HOME/bin/keyboard_setup.sh
/usr/bin/env xscreensaver -no-splash &
/usr/bin/env xbindkeys
/usr/bin/env xset -b
/usr/bin/env xss-lock -- /usr/bin/env xscreensaver-command --lock &
/usr/bin/env pasystray &
/usr/bin/env xsetroot -solid midnightblue
/usr/bin/env trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 100 --widthtype pixel --transparent true --alpha 0 --tint 0x000000 --height 18 &
exec xmonad
