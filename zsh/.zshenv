export TZ=America/New_York
export EDITOR=nvim
export TERMINAL=urxvt
export EMACSDIR=$HOME/.emacs.d
export LEDGER_FILE=$HOME/org/hledger/$(date +%Y).journal
PATH="$HOME/bin:$HOME/.emacs.d/bin:$PATH"

alias e="emacsclient -n"
alias dmenu=rofi
alias dmenu_run="rofi -show run"
source ~/.zshenv.local
