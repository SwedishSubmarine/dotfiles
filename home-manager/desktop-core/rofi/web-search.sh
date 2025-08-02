#!/usr/bin/env bash

declare -A URLS

# URL list changed from https://github.com/miroslavvidovic/rofi-scripts/blob/master/web-search.sh

URLS=(
  ["duckduckgo"]="https://www.duckduckgo.com/?q="
  ["nixpkgs"]="https://search.nixos.org/packages?query="
  ["nixopts"]="https://search.nixos.org/options?query="
  ["home-manager"]="https://home-manager-options.extranix.com/?query="
)

# List for rofi
gen_list() {
    for i in "${!URLS[@]}"
    do
      echo "$i"
    done
}

main() {
  # Pass the list to rofi
  platform=$( (gen_list) | rofi -dmenu -matching fuzzy -no-custom -p "Platform > " )

  if [[ -n "$platform" ]]; then
    query=$( (echo ) | rofi  -dmenu -matching fuzzy -p "$platform > " )

    if [[ -n "$query" ]]; then
      url=${URLS[$platform]}$query
      xdg-open "$url"
    else
      exit
    fi

  else
    exit
  fi
}

main

exit 0
