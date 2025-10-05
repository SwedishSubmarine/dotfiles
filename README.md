# Notes
NixOS configuration currently managing 
* **Adamantite**, My M2 MacBook Air, running NixOS under asahi
* **Beskar**, My Desktop using nixpkgs-unstable for everything
* **Eridium**, My 2018 MacBook Pro, with a T2 security chip.
* **Uru**, My temporary server, an old Mac Mini, with a T2 security chip.

## Structure
- `colors.nix`: Colorscheme configuration
- `flake.nix`: Flake defining my configurations
- `home-manager`: Home-manager modules
- `nixos`: NixOS configuration modules
- `secrets`: Git-crypt encrypted secrets
- `wallpapers`: All the wallpapers that I use, used for `sddm` and `swww`

## Colors 
I use colors.nix and inherit a theme to change colors. Call a certain color
with `${theme.current.<color>}`. I will try to stick with these colors to make
changing theme easier: 
* `accent` (main accent)
    * For gruvbox I use light yellow and for catppuccin I use mauve.
* `accent2` (secondary accent)
    * For gruvbox I use dark yellow and for catppuccin I use pink.
* `text1` (main text)
* `text2` (secondary text, slightly darker)
* `text3` (tertiary text, much darker)
* `base1` (main background color)
* `base2` (secondary background color, slightly darker)
* `surface0` (surface color, brighter than base)
* `overlay0` (overlay color)
* `overlay1` (brighter overlay color)

These colors are also used on occasion. Primarily for decoration elements like
waybar and swaylock. 
* `base3` (tertiary background color, much darker, using for swaylock)
* `surface1` (brighter surface color)
* `surface2` (brightest surface color)
* `overlay2` (brightest overlay color)
* `red` (using for swaylock mainly)
* `orange` (using for swaylock)
* `cyan` (using for swaylock)
* `blue` (using for swaylock and waybar) 
* `sky` (using for waybar)
* `teal` (using for waybar)
* `light-blue` (using for waybar)
* `yellow` (using lots for waybar)
* `green` (using for waybar)

Some colors are modified additionally for RGBA in certain spots. These are
mainly for niri at the moment, for focus ring for inactive windows (mainly when
niriswitcher is focused) and for dynamic casting stuff. Wezterm is also weird
because it has built in color schemes so I'll replace the colors I can and then
maybe fix it another time.

## Scripts
Most of my scripts are baked into certain configuration files.
This includes my `random-wallpaper` script which uses swww and runs as a systemd
service to randomize my wallpaper once per hour and my small calendar opening
script because xdg-open is mean to niri. 
I also have a few rofi scripts inside of `home-manager/desktop-core/rofi`. 
- `web-search.sh` Search things on ddg and for nix options and packages. You
  can add more URLs quite easily.
- `google.sh` Used to quickly open my calendar, drive and mail. Thunderbird just
  isn't very good in my experience.
- `rofi-power-menu` Small script to give me power options. Credit goes to 
[jluttine](https://github.com/jluttine/rofi-power-menu)
Thank god for this one because I could not have done it myself!
- `niri-action.sh` Used to run niri msg actions that I don't have easy keyboard
  access to. 

## Credits
Many of the catppuccin wallpapers are from Simon Stålenhag, his website can be [found
here](https://www.simonstalenhag.se/new/other.html), and from two git repos:
[zhichaohs
catppuccin-wallpapers](https://github.com/zhichaoh/catppuccin-wallpapers/tree/main)
repo forked from `vipinVIP/wallpapers` and [notAxons
wallpapers](https://github.com/notAxon/wallpapers/tree/main) repo.
The remainder are my own photographs.

For gruvbox I am also using may Simon Stålenhag wallpapers, but also a lot of
wallpapers found on [this website](https://gruvbox-wallpapers.pages.dev/).

The niri msg rofi menu is taken from my friend Xenia 🥺

## Random weird stuff
I generate the zsh folder within this directory, so I ignore `/zsh` but zsh
sucks so I still need to have a `.zshenv` file in my home directory.

Yes I use home-manager for my server, I really really really really need it I
promise (i do not)

### Colors
Yea it's weird I call it "Colors" at this point considering it's used for almost
all my theming. Thank god for my awesome girlfriend telling me I shuold just
handle theme stuff like this instead of having a bunch of long if statements
like I did originally. Those were gross and bad and this is cool and awesome.
Anyways it should be pretty extensible as long as you're a bit liberal with
color schemes to fit into this scheme. 

### Neovim
I use both vim config and lua config under `program.neovim` to set options. This
is because I'm stupid and now I find it too funny to change back so it stays. I
also handle autocmd stuff for markdown in vimscript because i just don't know
how to do it in lua sorgy ^^. 

I'm like 90% sure the way I handle transparency in neovim is just like way too
overcomplicated but it works so I'm rolling with it.

I use like only emoji completion ngl I have in the past just had cmp installed
for emojis and am considering getting rid of the rest again because I just don't
use them very much.

I use `programs.neovim.extraPackages` for language servers. I think this is
awesome and cool 🐈 

### Scripts 
My `google.sh` script sort of depends on you having a work and personal google
account and signing into your personal one first. I would not hardcode this if I
could but I thought this would be neat to have so I surrendered to it. 
