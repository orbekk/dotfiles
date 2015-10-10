#!/bin/bash
readonly XBACKLIGHT=xbacklight
readonly levels=(0 1 2 3 4 6 10 15 20 25 30 40 50 60 70 80 90 100)

current_level=$($XBACKLIGHT)
current_level=$((${current_level%.*}))

if (( "$current_level" < 8 )); then
    diff=1
elif (( "$current_level" < 24 )); then
    diff=6
elif (( "$current_level" < 50 )); then
    diff=12
else
    diff=24
fi

if [[ $1 == "+" ]]; then
    $XBACKLIGHT -inc $diff
elif [[ $1 == "-" ]]; then
    $XBACKLIGHT -dec $diff
else
    echo "Usage: $0 +|-"
    exit 1
fi
