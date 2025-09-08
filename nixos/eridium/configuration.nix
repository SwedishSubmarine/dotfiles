{ niri, yazi, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.firmware = [
	(pkgs.stdenvNoCC.mkDerivation (final: {	
    name = "brcm-firmware";
    src = ./firmware/brcm;
    installPhase = ''
      mkdir -p $out/lib/firmware/brcm
      cp ${final.src}/* "$out/lib/firmware/brcm"
    '';
    }))
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  nixpkgs.overlays = [ niri.overlays.niri yazi.overlays.default ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  networking.hostName = "Eridium"; # Define your hostname.

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
    background = "${../../wallpapers/wallpaper-theme-converter-25.png}";
    font = "MonaspiceRn Nerd Font";
    fontSize = "12";
    assertQt6Sddm = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    git-crypt
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

