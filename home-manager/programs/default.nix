{ config, pkgs, ... }:
{
  catppuccin = {
    flavor = "macchiatto";
    accent = "mauve";
  };

  imports = [
    ./bat.nix
  ];
