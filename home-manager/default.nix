{ pkgs, unstable, stable, settings, lib, ... }:
let 
  opt = lib.optional;
  opts = lib.optionals;
in
{
  home = {
    stateVersion = "25.05";
    packages =
      with pkgs;
      [
        # Terminal applications
        file
        wget
        yt-dlp
        ffmpeg
        _7zz
        ripgrep
        unzip
        cowsay
        ## Everything below will not be installed on a server
      ]
      ++ opts ( !settings.server)
      [
        resvg
        imagemagick
        cava
        wev
        nomad
        rbw
        wtype
        mesa-demos
        unstable.minefair
        unstable.widevine-cdm
        (python3.withPackages ( ps: with ps; [
          matplotlib
          numpy
          scipy
          psycopg2
        ]))

        # Graphical applications
        vimiv-qt
        texliveMedium
        latexrun
        zathura
        swww
        wl-color-picker
        pinentry-all
        prismlauncher
        firefox
        thunderbird
        wl-clipboard
        alacritty
        wezterm
        darktable
        signal-desktop
        poppler
        bitwarden-desktop
        unstable.niriswitcher
        rofi-rbw-wayland
        lyra-cursors
        way-displays
        nautilus
        qbittorrent
        freecad-wayland
        distrobox
        libreoffice
        easyeffects

        # Fonts
        fontconfig
        papirus-icon-theme
        times-newer-roman
        nerd-fonts.monaspace
        nerd-fonts.hack
        nerd-fonts.fira-code
        nerd-fonts.roboto-mono
        libertine
        roboto
        source-sans-pro
        font-awesome

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
        go
        cargo
        gcc
        mdbook
        nixfmt-rfc-style
        typst
        postgresql
      ]
      # x86 only :(
      ++ opt (!settings.asahi) stable.tidal-hifi
      ++ opts (settings.osu)
      [ 
        opentabletdriver
        zenity
        wget
        wootility
      ]
      ++ opts (settings.steam) 
      [
        #Mostly utilities
        gamescope
        gamemode
        mangohud
        protonup-ng
        steam-run
      ]; 
  };

  imports = [
      ./terminal-core/terminal.nix
      opt (!settings.server) ./programs
      opt (settings.niri) ./desktop-core/niri.nix
    ];
}
