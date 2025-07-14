#!/usr/bin/env bash

swww img $(find ./wallpapers/. -type f | shuf -n 1) -o eDP-1 --transition-type any --transition-fps 60
