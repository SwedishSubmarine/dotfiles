{ pkgs, settings, ... }:
{
  networking = {
    networkmanager.enable = true;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

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

  console = {
    keyMap = "sv-latin1";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Airplay
  # services.avahi.enable = true;
  # services.pipewire = {
  #   raopOpenFirewall = true;
  #   extraConfig.pipewire = {
  #     "10-airplay" = {
  #       "context.modules" = [
  #         {
  #           name = "libpipewire-module-raop-discover";
  #           args = {
  #             "raop.latency.ms" = 500;
  #           };
  #         }
  #       ];
  #     };
  #   };
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; 
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.icu ];
    };
  };
  programs.steam.enable = settings.steam;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM="wayland;xcb";
    CLUTTER_BACKEND="wayland";
    SDL_VIDEODRIVER="wayland,x11";
  };
}
