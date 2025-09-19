{ pkgs, inputs, asahi-firmware, ... }:
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
  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-macchiato";
      package = pkgs.kdePackages.sddm;
    };
  };

  catppuccin.sddm = { 
    enable = true;
    accentColor = "mauve";
    flavor = "macchiato";
    background = "${../../catppuccin-wallpapers/wallpaper-theme-converter-25.png}";
    font = "MonaspiceRn Nerd Font";
    fontSize = "12";
    assertQt6Sddm = true;
  };

  # Specify path to peripheral firmware files.
  # Private git-repo
  hardware.asahi.peripheralFirmwareDirectory = asahi-firmware;
  hardware.asahi.enable = true;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.setupAsahiSound = true;
  hardware.bluetooth.enable = true;

  # Enable CUPS to print documents. ??
  # services.printing.enable = true;

  services.libinput.enable = true;

  virtualisation.docker.enable = true;
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    git
    git-crypt
    binutils
    coreutils
  ];

  system.stateVersion = "25.11"; # Did you read the comment? yea probably :3
}
