{ pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./services/minecraft-server/minecraft-server.nix
    ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    systemd-boot.enable = true;
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

  networking.hostName = "Uru"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emily = {
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4 et@MacBook-Air-2.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h Emily@et"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPf88TE70rqAHBMs0dNbS/2sjkN6pZRA5LFt404HjUJF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIAhV0pza7k9wLkgBdXT00lbC+5QAZBUKQQxBnzAt90"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwDFb6rrgC+bMEcOtVpjKBlMp7XdLP0dZGBeZvI/B1h emily@Beskar"
    ];
    packages = with pkgs; [
      tree
      htop
      jdk23
      binutils
      coreutils
      lsof
      file
      traceroute
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim 
    wget
    git
    tmux
  ];

  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "05:00";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 8123];
  };

  system.stateVersion = "25.05"; 
}

