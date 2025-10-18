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
  boot.loader.systemd-boot.windows = {
    "10" = {
      title = "Windows 10 Home";
      efiDeviceHandle = "HD1c";
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.wooting.enable = true;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri inputs.yazi.overlays.default ];

  # Use latest kernel.
  time.timeZone = "Europe/Stockholm";
  networking.hostName = "Beskar"; # Define your hostname.
  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager = {
      plasma6.enable = true;
    };
    xserver.xkb = {
      layout = "se";
      variant = "nodeadkeys";
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    jellyfin = {
      enable = true;
      user = "emily";
      openFirewall = true;
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    neovim 
    git
    kdePackages.sddm-kcm
    kdePackages.kcalc
    wayland-utils
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
