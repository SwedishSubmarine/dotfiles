{ theme, pkgs, inputs, asahi-firmware, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../shared.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "Adamantite"; 
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
    ];
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri inputs.yazi.overlays.default ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  services.power-profiles-daemon.enable = true;
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
        extraPackages = with pkgs; [
          kdePackages.layer-shell-qt
          kdePackages.qt5compat
        ];
      };
      defaultSession = "niri";
    };
    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  origin-address  auth-method
        local all       all                     trust
        host  all       all     127.0.0.1/8     trust
        host  all       all     ::1/128         trust 
      '';
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    binutils
    coreutils
    docker-compose
    git
    git-crypt
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${../../gruvbox-wallpapers/gruvbox_astro.jpg}";
        passwordInputRadius = "10";
        passwordInputWidth = "0.25";
        passwordInputCursorVisible = "true";
        showSessionsByDefault = "true";
        showUsersByDefault = "true";
        usersFontSize = "32";
        backgroundMode = "aspect";
        passwordFontSize = "36";
        passwordCursorColor = "#${theme.current.accent}";
        passwordTextColor = "#${theme.current.accent}";
        basicTextColor = "#${theme.current.text1}";
        font = "Hack";
      };
    })
  ];

  # Specify path to peripheral firmware files.
  # Private git-repo
  hardware.asahi.peripheralFirmwareDirectory = asahi-firmware;
  hardware.asahi.enable = true;
  hardware.asahi.setupAsahiSound = true;
  hardware.bluetooth.enable = true;

  services.libinput.enable = true;

  virtualisation.docker.enable = true;
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment? yea probably :3
}
