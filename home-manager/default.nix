{  config, pkgs, ... }:
{
  home = {
    username = "emily";
    homeDirectory = "/home/emily";
    stateVersion = "25.05";

    packages = with pkgs; [
      wget
      imagemagick
      swww
      cava
      wev
      yt-dlp
      ffmpeg
      resvg
      _7zz

      chromium
      firefox
      thunderbird
      wl-clipboard
      alacritty
      wezterm
      vesktop
      darktable
      signal-desktop
      poppler

      fontconfig
      nerd-fonts.monaspace
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.roboto-mono

      gnome-keyring

      xwayland-satellite
      libnotify
      rofi-wayland
      networkmanagerapplet
      pavucontrol
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

