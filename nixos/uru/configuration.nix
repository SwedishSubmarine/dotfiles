# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./services/minecraft-server/minecraft-server.nix
    ];

  # Use the systemd-boot EFI boot loader.

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    systemd-boot.enable = true;
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin= "no";
  services.fail2ban = {
    enable = true;	
    ignoreIP = [
      "nixos.wiki" "192.168.0.0/16"
    ];
  };


  networking.hostName = "Uru"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4 et@MacBook-Air-2.local"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h Emily@et"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARypcjzq0rpw1YRa8IJ91SsC4jrXgbB0SaYHfSlb9T4"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSV2IFijYoSfeYkUENWbZZM9yLR2xl5tpJ6xlK/11h"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPf88TE70rqAHBMs0dNbS/2sjkN6pZRA5LFt404HjUJF"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIAhV0pza7k9wLkgBdXT00lbC+5QAZBUKQQxBnzAt90"
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

  programs.bash.interactiveShellInit = ''
    set -o vi
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    allowedTCPPorts = [ 25565 8123];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

