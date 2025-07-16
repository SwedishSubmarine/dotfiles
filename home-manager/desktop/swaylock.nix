{ config, pkgs, ... }:
{
programs.swaylock = {
  enable = true;
  package = pkgs.swaylock-effects;
  settings = {
    screenshots = true;
    effect-blur = "15x3";
    effect-vignette = "0.4:0.2";
    clock = true;
    grace = 0;

    indicator = true;
    indicator-radius = 200;
    indicator-caps-lock = true;

    # Colors - Based on catppuccin macchiato
    ring-color = "c6a0f6"; # Mauve
    ring-clear-color = "24273a"; # Base
    ring-caps-lock-color = "f5a97f"; # Peach
    ring-ver-color = "8aadf4"; # Blue
    ring-wrong-color = "ed8796"; # Red

    key-hl-color = "24273aF0"; # Base ~94% opacity
    caps-lock-key-hl-color = "24273aF0"; # Base ~94% opacity
    bs-hl-color = "ed8796"; # Red
    caps-lock-bs-hl-color = "ed8796"; # Red

    line-uses-inside = true;

    inside-color = "24273a80"; # Base ~50% opacity
    inside-clear-color = "18192680"; # Crust ~50% opacity
    inside-caps-lock-color = "24273a80"; # Base ~50% opacity
    inside-ver-color = "#7dc4e480"; # Sapphire ~50% Opacity
    inside-wrong-color = "ed879660"; # Red ~38% Opacity

    separator-color = "00000000"; #GET OUTTA HERE

    text-color = "cad3f5"; # Text
    text-clear-color = "a5adcb"; # Subtext 0 
    text-caps-lock-color = "cad3f5"; # Text
    text-ver-color = "8aadf4"; # Blue
    text-wrong-color  = "ed8796"; # Red
  };
};
}
