{ pkgs, ... }:
{
  home = {
    username = "emily";
    homeDirectory = "/home/emily";
    stateVersion = "25.05";

    packages = with pkgs; [
      # Terminal applications
      wget
      imagemagick
      swww
      cava
      wev
      yt-dlp
      ffmpeg
      resvg
      _7zz
      ripgrep
      unzip
      wl-color-picker

      # Graphical applications
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

      # Fonts
      fontconfig
      papirus-icon-theme
      nerd-fonts.monaspace
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.roboto-mono

      # Gnome
      gnome-keyring

      # Utilities (Mainly for waybar)
      xwayland-satellite
      libnotify
      networkmanagerapplet
      pavucontrol
      brightnessctl
      playerctl
      blueberry

      #Languages
      elixir
      ghc
      cargo
      gcc
      mdbook
      nixfmt-rfc-style
      typst
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
