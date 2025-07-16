{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${./rounded.rasi}";
    extraConfig = {
      matching = "fuzzy";
    };
  };
}
