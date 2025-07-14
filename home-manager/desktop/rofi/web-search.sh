#!/usr/bin/env bash

query=$( (echo ) | rofi -dmenu -matching fuzzy -p "Web search > " )

  if [[ -n "$query" ]]; then
    url="https://www.duckduckgo.com/?q="$query
    xdg-open "$url"
  else
    exit
  fi

exit 0
