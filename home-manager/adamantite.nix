{ pkgs, unstable, ... }:
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
      nomad
      cowsay
      rbw
      pinentry-all
      wtype
      prismlauncher

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
      bitwarden
      unstable.niriswitcher
      rofi-rbw-wayland

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

      #Languages and frameworks
      elixir
      ghc
      cargo
      gcc
      mdbook
      nixfmt-rfc-style
      typst
      python3
    ];
  };

  imports = [
    ./terminal-core/terminal.nix
    ./desktop-core/desktop.nix
    ./programs
  ];
}
