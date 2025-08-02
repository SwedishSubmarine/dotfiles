{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${./rounded.rasi}";
    extraConfig = {
      matching = "fuzzy";
    };
    plugins = with pkgs; [
      rofi-rbw
    ];
  };
}
