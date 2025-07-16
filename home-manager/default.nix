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
      imagemagick
      swww
      cava
      bottom
      wev
      fzf

      chromium
      firefox
      thunderbird
      wl-clipboard
      alacritty
      wezterm
      vesktop
      darktable
      signal-desktop
      obs-studio
      zathura
      mpv

      fontconfig
      nerd-fonts.monaspace
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.roboto-mono

      xwayland-satellite
      libnotify
      rofi-wayland
      networkmanagerapplet
      pwvucontrol 
      brightnessctl
      playerctl
      blueberry

      ghc
      mdbook
    ];
  };

  imports = [
    ./terminal-core/neovim.nix
    ./terminal-core/zsh.nix
    ./terminal-core/wezterm.nix
    ./terminal-core/git.nix
    ./desktop-core/xdg.nix
    ./desktop-core/graphical.nix
    ./desktop-core/swaylock.nix
    ./desktop-core/waybar.nix
    ./programs/default.nix
  ];
}

