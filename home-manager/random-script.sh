#!/usr/bin/env bash
swww img $(find ~/dotfiles/home-manager/wallpapers/. -type f | shuf -n 1) --outputs eDP-1 --transition-type any --transition-fps 60
