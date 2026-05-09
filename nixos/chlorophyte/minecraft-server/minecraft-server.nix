{ pkgs, inputs, config, ... }:
{
  imports =
    [
     inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

  nixpkgs.overlays = 
    [
      inputs.nix-minecraft.overlay
    ];

  services.minecraft-servers = {
    managementSystem.systemd-socket.enable = true;
    enable = true;
    eula = true;
    # dataDir = "/minecraft/server";
    # managementSystem.tmux.enable = true;

    servers = {
      qwdcraft = {
        enable = true;
        restart = "always";
        package =  pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };
        jvmOpts = "-Xms12576M -Xmx12576M -XX:+UseG1GC";
        serverProperties = {
          difficulty = "hard";
          gamemode = "survival";
          level-name = "qwdcraft";
          view-distance = 12;
          allow-flight = true;
          enable-command-block = true;
          max-players = 21;
          white-list = true;
          enforce-whitelist = true;
          motd = "Qwdcraft yay yay yippee ^_^ !";
          spawn-protection = 0;
          op-permission-level = 4;
        };
          symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            FabricAPI = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dZsorAUN/fabric-api-0.147.0%2B26.1.2.jar?mr_download_reason=standalone"; 
              sha256 = "sha256-q3h3qPfI5HVw0+txBLL7LzoyT21lU1b+c5Z/LTKQurg=";
            };
            FerriteCore = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar?mr_download_reason=standalone"; 
              sha256 = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
            };
            Lithium = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/R7MxYvuW/lithium-fabric-0.24.2%2Bmc26.1.2.jar?mr_download_reason=standalone";
              sha256 = "sha256-IlKJ8aLw4nSbNl9lpJwD6o9FJEXkmJmVEME8s5ndTgA=";
            };
            Carpet = pkgs.fetchurl {
              url = "https://github.com/gnembon/fabric-carpet/releases/download/v26.1/fabric-carpet-26.1+v260402.jar";
              sha256 = "sha256-Wb0iXRJCOn16Y1ygyU+nhvl8zrsRaSKxbXYHLaTuZ+c=";
            };
            ViewDistanceFix = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/nxrXbh5K/versions/vH4elviA/viewdistancefix-fabric-1.0.2%2B26.1.2.jar?mr_download_reason=standalone"; 
              sha256 = "sha256-XddM2G9gRSMcHB7h8TKst5QypDFIvqwuwwM0jmZmRoU=";
            };
            Servux = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/eu63Kj9A/servux-fabric-26.1.2-0.10.2.jar?mr_download_reason=standalone"; 
              sha256 = "sha256-TgER/TnR+xEHUU8r5X3xOynFrDG007MwbeppkTMEYO8=";
            };
            BlueMap = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/swbUV1cr/versions/D9j76thC/bluemap-5.20-fabric.jar?mr_download_reason=standalone"; 
              sha256 = "sha256-ZO1PAAmfRtN21vL/Vq1thOtCie2Gxir+f84t/TW+siY=";
            };
            PlayerRoles = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/Rt1mrUHm/versions/iFL75Q1d/player-roles-1.9.0-pre.1.jar?mr_download_reason=standalone";        
              sha256 = "sha256-TdWKKqX1+OaAJ8BLeOJ5n6T+PWCu6TXCB4g6PfSR1u8=";
            };
          }); 
	      };
      };
    };
  };
}
