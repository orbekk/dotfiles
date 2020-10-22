#!/usr/bin/env bash
readonly XBACKLIGHT=xbacklight

current_level=$($XBACKLIGHT)
current_level=$((${current_level%.*}))

if (( "$current_level" < 8 )); then
    diff=1
elif (( "$current_level" < 24 )); then
    diff=6
else
    diff=10
fi

if [[ $1 == "+" ]]; then
    $XBACKLIGHT -inc $diff
elif [[ $1 == "-" ]]; then
    $XBACKLIGHT -dec $diff
else
    echo "Usage: $0 +|-"
    exit 1
fi
