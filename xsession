#!/usr/bin/env bash

export TERMINAL=urxvt
export MPD_HOST=sabaki.kk.orbekk.com
command -v $TERMINAL || TERMINAL=termite
command -v $TERMINAL || TERMINAL=gnome-terminal
PATH=$HOME/.cabal/bin:$PATH
xrdb -merge $HOME/.Xresources
setxkbmap us -variant dvorak -option compose:ralt -option caps:ctrl_modifier
$HOME/bin/keyboard_setup.sh
xscreensaver -no-splash &
xbindkeys
xset -b
xss-lock -- /usr/bin/env xscreensaver-command --lock &
pasystray &
xsetroot -solid "#2A3462"
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 100 --widthtype pixel --transparent true --alpha 0 --tint 0x000000 --height 18 &
[[ $(hostname) == kikashi ]] && \
  xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.5
if [[ $(hostname) == orange.nyc.corp.google.com ]]; then
  xinput set-prop "Logitech USB Trackball" "Device Accel Constant Deceleration" 1.0
  xinput set-prop "Logitech USB Trackball" "Evdev Wheel Emulation" 1       
  xinput set-prop "Logitech USB Trackball" "Evdev Wheel Emulation Button" 8
  true
fi
if [[ $(hostname) == pincer ]]; then
  # xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.5
  # xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Constant Deceleration" 0.5
  true
fi
[[ -f /etc/nixos/configuration.nix ]] || \
  redshift -l 40:-70 -r -t 5500:3700 &
exec xmonad
