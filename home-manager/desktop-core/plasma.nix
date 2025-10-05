{ settings, inputs, config, pkgs, theme, ...}: 
{
  imports = [
    ./rofi/rofi.nix
    ./xdg.nix
  ];
}
