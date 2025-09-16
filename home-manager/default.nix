{ pkgs, unstable, settings, ... }:
{
  home = {
    stateVersion = "25.05";
    
    packages = with pkgs; [
      # Terminal applications
      wget
      yt-dlp
      ffmpeg
      _7zz
      ripgrep
      unzip
      cowsay

      ## Everything below will not be installed on a server
    ] ++ (if !settings.server then [
      resvg
      imagemagick
      cava
      wev
      nomad
      rbw
      wtype
      unstable.minefair

      # Graphical applications
      swww
      wl-color-picker
      pinentry-all
      prismlauncher
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
      lyra-cursors
      way-displays

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
    ] else []);
  };

  imports = [
    ./terminal-core/terminal.nix
    ] ++ (if !settings.server then [
    ./desktop-core/graphical.nix
    ./programs
    ] else []);
}
