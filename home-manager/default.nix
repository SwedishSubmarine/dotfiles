{ pkgs, unstable, settings, ... }:
{
  home = {
    stateVersion = "25.05";

    packages =
      with pkgs;
      [
        # Terminal applications
        wget
        yt-dlp
        ffmpeg
        _7zz
        ripgrep
        unzip
        cowsay
        ## Everything below will not be installed on a server
      ]
      ++ ( if !settings.server then
      [
        resvg
        imagemagick
        cava
        wev
        nomad
        rbw
        wtype
        unstable.minefair
        unstable.widevine-cdm
        (python3.withPackages ( ps: with ps; [
          matplotlib
          numpy
          scipy
        ]))

        # Graphical applications
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
        vesktop
        darktable
        signal-desktop
        poppler
        bitwarden
        unstable.niriswitcher
        rofi-rbw-wayland
        lyra-cursors
        way-displays
        nautilus
        qbittorrent
        freecad-wayland

        # Fonts
        fontconfig
        papirus-icon-theme
        nerd-fonts.monaspace
        nerd-fonts.hack
        nerd-fonts.fira-code
        nerd-fonts.roboto-mono
        libertine

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
      ] else [])
      # x86 only :(
      ++ (if !settings.asahi then
      [
        tidal-hifi
      ] else [])
      ++ (if settings.osu then 
      [ 
        osu-lazer-bin
        opentabletdriver
        zenity
        wget
        wootility
      ] else [])
      ++ (if settings.steam then 
      [
        #Mostly utilities
        gamescope
        gamemode
        mangohud
        protonup
        protontricks
      ] else []);
  };

  imports =
    [
      ./terminal-core/terminal.nix
    ]
    ++ ( if !settings.server then
        [ ./programs ]
      else []) ++ (
      if settings.niri then
        [ ./desktop-core/niri.nix ]
      else if settings.kde then
        [ ./desktop-core/plasma.nix ]
      else []);
}
