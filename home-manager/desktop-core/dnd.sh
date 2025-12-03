#!/bin/sh
statefile="$HOME/.cache/dnd_state"

if [[ -f "$HOME/.cache/dnd_state" ]] ; then
  state=$(cat "$statefile")
else 
  state="unmuted"
fi

if [ "$state" == "unmuted" ] ; then 
  notify-send 'Do not disturb turned on 🌙'
  echo "muted" > "$statefile"
  sleep 1
  makoctl mode -s dnd 
else 
  notify-send 'Do not disturb turned off 🔈'
  echo "unmuted" > "$statefile"
  makoctl mode -s default 
fi 
