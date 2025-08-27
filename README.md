# Notes
NixOS configuration currently managing my M2 MacBook Air, **Adamantite** running nixOS under asahi as well as my server, an old Mac Mini, **Uru**. 

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
* `accent2` (secondary accent)
* `text1` (main text)
* `text2` (secondary text, slightly darker)
* `text3` (tertiary text, much darker)
* `base1` (main background color)
* `base2` (secondary background color, slightly darker)
* `surface0` (surface color, brighter than base)
* `overlay0` (overlay color)
* `overlay1` (brighter overlay color)

On rare occasions I will also use these colors, they're way more specific to my
current colorscheme, _catppuccin macchiato_, so they may be harder to adjust for
other colorschemes.
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
* `pink` (using for fastfetch)

In certain locations, like in `graphical.nix` I use edited versions
of my current colorscheme, such as for inactive windows focus ring which
are less saturated versions of lavender and mauve. I am too lazy to write a
library myself to adjust the saturation of hex colors so for now they will
remain as they are. These are mainly for niri at the moment, for focus ring for
inactive windows (mainly when niriswitcher is focused) and for dynamic casting
stuff. There *might* also be one for swaylock but I can't recall.
Wezterm is also weird because it has built in color schemes so I'll replace the
colors I can and then maybe fix it another time.

## Credits
I believe all the wallpapers that are not mine are taken from [zhichaohs
catppuccin-wallpapers](https://github.com/zhichaoh/catppuccin-wallpapers/tree/main)
repo forked from `vipinVIP/wallpapers`.

The rofi power menu script is found in the [jluttine
rofi-power-menu](https://github.com/jluttine/rofi-power-menu/tree/master) repo.
Thank god for this one because I could not have done it myself!

The niri msg rofi menu is taken from my friend Xenia 🥺

## Random weird stuff
I generate the zsh folder within this directory, so I ignore `/zsh` but zsh
sucks so I still need to have a `.zshenv` file in my home directory.

Yes I use home-manager for my server, I really really really really need it I
promise (i do not)

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
