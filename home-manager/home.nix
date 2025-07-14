{  config, pkgs, ... }:
{
  home = {
    username = "emily";
    homeDirectory = "/home/emily";
    stateVersion = "25.05";

    packages = with pkgs; [
      wget
      eza
      zoxide
      fastfetch

      chromium
      firefox
      wl-clipboard
      alacritty
      wezterm
      vesktop
      darktable
      signal-desktop

      fontconfig
      nerd-fonts.monaspace
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.roboto-mono

      xwayland-satellite
      swww
      libnotify
      rofi-wayland
      networkmanagerapplet
      pwvucontrol 
      brightnessctl
      playerctl
      blueberry

      ghc
      cava
    ];
  };

  imports = [
    ./neovim.nix
    ./zsh.nix
    ./wezterm.nix
    ./graphical.nix
    ./xdg.nix
    ./waybar.nix
    ./git.nix
  ];
}

