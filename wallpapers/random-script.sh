#!/usr/bin/env bash
swww img $(find ~/dotfiles/wallpapers/ -type f \( -name '*.png' -o -name '*.jpg' \) | shuf -n 1) --outputs eDP-1 --transition-type any --transition-fps 60
