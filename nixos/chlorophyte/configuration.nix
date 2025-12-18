{ pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
 
  hardware.i2c.enable = true;
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  services.xserver.videoDrivers = [ "nvidia" ]; 
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
    };
  };
  fileSystems = {
    "/mnt/data4TB" = {
      device = "/dev/disk/by-uuid/DC3A-2C1A";
      fsType = "exfat";
      # options = [ "users" "nofail" ];
    };
    "/mnt/data3TB" = {
      device = "/dev/disk/by-uuid/25c17c84-0b18-429b-8040-c16720d61c45";
      fsType = "ext4";
    };
  };

  services.jellyfin = {
    enable = true;
    user = "emily";
    openFirewall = true;
  };

  services.hardware = {
    openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin= "no";
  services.openssh.passwordAuthentication = false;
  services.fail2ban = {
    enable = true;	
    ignoreIP = [
      "nixos.wiki" "192.168.0.0/16"
    ];
  };

  networking.hostName = "Chlorophyte"; # Define your hostname.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Stockholm";

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  console.keyMap = "sv-latin1";

  users.users.emily = {
    isNormalUser = true;
    description = "emily";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4 et@MacBook-Air-2.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h Emily@et"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPf88TE70rqAHBMs0dNbS/2sjkN6pZRA5LFt404HjUJF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIAhV0pza7k9wLkgBdXT00lbC+5QAZBUKQQxBnzAt90"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwDFb6rrgC+bMEcOtVpjKBlMp7XdLP0dZGBeZvI/B1h emily@Beskar"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "05:00";
  };

  environment.systemPackages = with pkgs; [
	  neovim
	  git
    git-crypt
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # networking.firewall.allowedTCPPorts = [ ... ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
