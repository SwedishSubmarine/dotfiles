{ pkgs, ... }:
let
    rgb-off = pkgs.writeScript "rgb-off" ''
    #!/usr/bin/env bash
    for i in {0..3}; do 
      openrgb -d $i -m Off; 
    done
    '';
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./minecraft-server/minecraft-server.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
 
  hardware.i2c.enable = true;
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  services.xserver.videoDrivers = [ "modesetting" ]; 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
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
    "/export/data4TB" = {
      device = "/mnt/data4TB/";
      options = [ "bind" "nfsvers=4.2"];
    };
    "/export/data3TB" = {
      device = "/mnt/data3TB/";
      options = [ "bind" "nfsvers=4.2"];
    };
  };
  
  services.jellyfin = {
    enable = true;
    user = "emily";
    openFirewall = true;
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export         192.168.1.0/24(rw,fsid=0,no_subtree_check)
      /export/data3TB 192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
      /export/data4TB 192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
    '';
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "bozo.life" = {
        serverAliases = [ "www.bozo.life" ];
        extraConfig = ''
        '';
      };
      "watching.bozo.life" = {
        serverAliases = [ "www.watching.bozo.life" ];
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
      '';
      };
      "blocky.bozo.life" = {
        serverAliases = [ "www.blocky.bozo.life" ];
        extraConfig = ''
          reverse_proxy 127.0.0.1:8101
      '';
      };
      "fuck.my.bozo.life" = {
        serverAliases = [ "www.fuck.my.bozo.life" ];
        extraConfig = ''
          reverse_proxy 127.0.0.1:8100
      '';
      };
    };
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
    extraGroups = [ "networkmanager" "wheel" "minecraft" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
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

  networking.firewall = {
    allowedTCPPorts = [ 80 443 2049 25565 42069 ];
    allowPing = false;
  };
  systemd.user.services.rgb = {
    unitConfig = {
      Description = "Disables RGB for memory on boot";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${rgb-off}";
    };
    wantedBy = [ "multi-user.target" ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
