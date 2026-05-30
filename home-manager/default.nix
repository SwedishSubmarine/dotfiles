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
        _7zz
        cowsay
        ffmpeg
        file
        ripgrep
        unzip
        wget
        yt-dlp
        ## Everything below will not be installed on a server
      ]
      ++ opts (!settings.server)
      [
        cava
        imagemagick
        mesa-demos
        mesa-demos
        nomad
        rbw
        resvg
        stable.greed
        unstable.minefair
        unstable.widevine-cdm
        wev
        wtype
        wtype
        (python3.withPackages ( ps: with ps; [
          matplotlib
          numpy
          psycopg2
          scipy
        ]))

        # Graphical applications
        alacritty
        darktable
        distrobox
        easyeffects
        firefox
        gimp
        kdePackages.gwenview
        kdePackages.kdenlive
        latexrun
        libreoffice
        lyra-cursors
        melonds
        nautilus
        pinentry-all
        poppler
        prismlauncher
        qbittorrent
        rofi-rbw-wayland
        signal-desktop
        stable.bitwarden-desktop
        awww 
        texliveMedium
        thunderbird
        unstable.niriswitcher
        vimiv-qt
        way-displays
        wezterm
        wl-clipboard
        wl-color-picker
        zathura

        # Fonts
        font-awesome
        fontconfig
        libertine
        lmodern
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.monaspace
        nerd-fonts.roboto-mono
        papirus-icon-theme
        roboto
        source-sans-pro
        times-newer-roman

        # Gnome
        gnome-keyring

        # Utilities (Mainly for waybar)
        brightnessctl
        libnotify
        networkmanagerapplet
        pavucontrol
        playerctl
        xwayland-satellite

        #Languages and frameworks
        cargo
        elixir
        gcc
        ghc
        go
        mdbook
        nixfmt-rfc-style
        postgresql
        typst
      ]
      # x86 only :(
      ++ opt (!settings.asahi && !settings.server) stable.tidal-hifi
      ++ opts (settings.osu)
      [ 
        opentabletdriver
        wget
        wootility
        zenity
      ]
      ++ opts (settings.steam) 
      [
        #Mostly utilities
        gamemode
        gamescope
        mangohud
        protonup-ng
        steam-run
      ]; 
  };

  imports = (
    [./terminal-core/terminal.nix]
    ++ opt (!settings.server) ./programs
    ++ opt (settings.niri) ./desktop-core/niri.nix
  );
}
