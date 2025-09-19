{ pkgs, theme, ... }:
{
programs.swaylock = {
  enable = true;
  package = pkgs.swaylock-effects;
  settings = {
    screenshots = true;
    effect-blur = "15x3";
    # effect-vignette = "0.4:0.2";
    clock = true;
    grace = 0;

    indicator = true;
    indicator-radius = 200;
    indicator-caps-lock = true;

    # Colors 
    ring-color = "${theme.current.accent}"; # Mauve
    ring-clear-color = "${theme.current.base1}"; # Base
    ring-caps-lock-color = "${theme.current.orange}"; # Peach
    ring-ver-color = "${theme.current.blue}"; # Blue
    ring-wrong-color = "${theme.current.red}"; # Red

    key-hl-color = "${theme.current.base1}F0"; # Base ~94% opacity
    caps-lock-key-hl-color = "${theme.current.base1}F0"; # Base ~94% opacity
    bs-hl-color = "${theme.current.red}"; # Red
    caps-lock-bs-hl-color = "${theme.current.red}"; # Red

    line-uses-inside = true;

    inside-color = "${theme.current.base1}80"; # Base ~50% opacity
    inside-clear-color = "${theme.current.base3}80"; # Crust ~50% opacity
    inside-caps-lock-color = "${theme.current.base1}80"; # Base ~50% opacity
    inside-ver-color = "${theme.current.cyan}80"; # Sapphire ~50% Opacity
    inside-wrong-color = "${theme.current.red}60"; # Red ~38% Opacity

    separator-color = "00000000"; #GET OUTTA HERE

    text-color = "${theme.current.text1}"; # Text
    text-clear-color = "${theme.current.text3}"; # Subtext 0 
    text-caps-lock-color = "${theme.current.text1}"; # Text
    text-ver-color = "${theme.current.blue}"; # Blue
    text-wrong-color  = "${theme.current.red}"; # Red
  };
};
}
