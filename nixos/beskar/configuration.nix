{ config, pkgs, theme, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  # Bootloader.
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.overlays = [ inputs.niri.overlays.niri inputs.yazi.overlays.default ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  services.desktopManager.plasma6.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "Beskar"; # Define your hostname.
  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "niri";
    };
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  environment.systemPackages = with pkgs; [
    neovim 
    git
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
