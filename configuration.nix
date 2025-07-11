{ asahi-firmware, ... }:
{ config, lib, pkgs, niri, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "Adamantine"; 
  networking.networkmanager.enable = true;  
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Standards
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "sv-latin1";
  };

  nixpkgs.config.allowUnfree = true; 
  nixpkgs.overlays = [ niri.overlays.niri ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
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

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.libinput.enable = true;

  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git
    binutils
    coreutils
    power-profiles-daemon
  ];

  services.desktopManager.plasma6.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment? yea probably :3

}
