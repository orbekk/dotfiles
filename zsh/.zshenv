export TZ=America/New_York
export EDITOR=nvim
export TERMINAL=urxvt
export EMACSDIR=$HOME/.emacs.d
export LEDGER_FILE=$HOME/org/hledger/$(date +%Y).journal
## For wayland
# export MOZ_ENABLE_WAYLAND=1
# export GDK_SCALE=2

PATH="$HOME/bin:$HOME/.emacs.d/bin:$PATH"

alias e="emacsclient -n"
alias dmenu=rofi
alias dmenu_run="rofi -show run"
source ~/.zshenv.local
