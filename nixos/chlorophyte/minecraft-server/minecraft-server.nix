{ pkgs, inputs, ... }:
let 
  makeWarningScript = pkgs.writeScript "warning" ''
    echo '/tellraw @a ["",{"text":"["},{"text":"Gooncraft ","color":"yellow"},{"text":"will be closing in"},{"text":" ","color":"yellow"},{"text":"'"$1"'","bold":true,"underlined":true,"color":"red"},{"text":"]"}]' > /run/minecraft/gooncraft.stdin
  '';
  makeWarning = minute: hour: time: day: ''${minute} ${hour} * * ${day} root ${makeWarningScript} "${time}"'';

  makeMods = inp: pkgs.linkFarmFromDrvs "mods" (builtins.attrValues inp);
  mods = {
    FabricAPI = pkgs.fetchurl { 
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dZsorAUN/fabric-api-0.147.0%2B26.1.2.jar"; 
      sha256 = "sha256-q3h3qPfI5HVw0+txBLL7LzoyT21lU1b+c5Z/LTKQurg=";
    };
    FerriteCore = pkgs.fetchurl { 
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar"; 
      sha256 = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
    };
    Lithium = pkgs.fetchurl { 
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/R7MxYvuW/lithium-fabric-0.24.2%2Bmc26.1.2.jar";
      sha256 = "sha256-IlKJ8aLw4nSbNl9lpJwD6o9FJEXkmJmVEME8s5ndTgA=";
    };
    Carpet = pkgs.fetchurl {
      url = "https://github.com/gnembon/fabric-carpet/releases/download/v26.1/fabric-carpet-26.1+v260402.jar";
      sha256 = "sha256-Wb0iXRJCOn16Y1ygyU+nhvl8zrsRaSKxbXYHLaTuZ+c=";
    };
    ViewDistanceFix = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/nxrXbh5K/versions/vH4elviA/viewdistancefix-fabric-1.0.2%2B26.1.2.jar"; 
      sha256 = "sha256-XddM2G9gRSMcHB7h8TKst5QypDFIvqwuwwM0jmZmRoU=";
    };
    Servux = pkgs.fetchurl { 
      url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/eu63Kj9A/servux-fabric-26.1.2-0.10.2.jar"; 
      sha256 = "sha256-TgER/TnR+xEHUU8r5X3xOynFrDG007MwbeppkTMEYO8=";
    };
    BlueMap = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/swbUV1cr/versions/D9j76thC/bluemap-5.20-fabric.jar"; 
      sha256 = "sha256-ZO1PAAmfRtN21vL/Vq1thOtCie2Gxir+f84t/TW+siY=";
    };
    BlueMapMarker = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/a8UoyV2h/versions/ZRiVWoLD/bmm-fabric-2.1.14.jar";
      sha256 = "sha256-BZXg8owBOaFoq/oGa6zmKi8oHuL4ilfC8h563zwDSRI=";
    };
    silk = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/q1yj6MMx/silk-all-1.11.6.jar";
      sha256 = "sha256-ccX827XSfRTGqsaIGUEU4hXMC0IyT0oYN63F2MPg/Fo=";
    };
    kotlin = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/2i87JpYj/fabric-language-kotlin-1.13.11%2Bkotlin.2.3.21.jar";
      sha256 = "sha256-w1cT7h2nD95r8OntJvjiuvCBTmDrmTzRKsuUDlf0/S8=";
    };
    PlayerRoles = pkgs.fetchurl { 
      url = "https://cdn.modrinth.com/data/Rt1mrUHm/versions/iFL75Q1d/player-roles-1.9.0-pre.1.jar";        
      sha256 = "sha256-TdWKKqX1+OaAJ8BLeOJ5n6T+PWCu6TXCB4g6PfSR1u8=";
    };
  }; 
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    managementSystem.systemd-socket.enable = true;
    enable = true;
    eula = true;
    servers = {
      qwdcraft = {
        enable = true;
        restart = "always";
        package =  pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };
        jvmOpts = "-Xms12576M -Xmx12576M -XX:+UseG1GC";
          symlinks = { mods = makeMods mods; };
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
      };
      gooncraft = {
        enable = true;
        autoStart = false;
        restart = "always";
        package =  pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };
        jvmOpts = "-Xms12576M -Xmx12576M -XX:+UseG1GC";
        symlinks = { 
          mods = makeMods (mods // {
            voiceChat = pkgs.fetchurl { 
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/DpT86E4Q/voicechat-fabric-2.6.18%2B26.1.2.jar";        
              sha256 = "sha256-cnoPh1vvXhfFkyp5tzFTPFKqmRGYnfFAvxFvB6EGx0o=";
            };
          });
        };
        serverProperties = {
          difficulty = "hard";
          gamemode = "survival";
          level-name = "gooncraft";
          view-distance = 12;
          allow-flight = true;
          enable-command-block = true;
          max-players = 21;
          white-list = true;
          enforce-whitelist = true;
          motd = "Beware of the goon";
          spawn-protection = 0;
          op-permission-level = 4;
          server-port = 42069;
          level-seed = 8500081009970950196;
        };
      };
    };
  };
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Tuesday
      "0  19 * * 2 root systemctl start minecraft-server-gooncraft >/dev/null 2>&1"
      "0  23  * * 2 root systemctl stop  minecraft-server-gooncraft >/dev/null 2>&1"
      (makeWarning "0" "22" "1 hour" "2")
      (makeWarning "30" "22" "30 minutes" "2")
      (makeWarning "45" "22" "15 minutes" "2")
      (makeWarning "55" "22" "5 minutes!!" "2")
      # Saturday
      "0  19 * * 6 root systemctl start minecraft-server-gooncraft >/dev/null 2>&1"
      # Sunday
      "0  2  * * 0 root systemctl stop  minecraft-server-gooncraft >/dev/null 2>&1"
      (makeWarning "0" "1" "1 hour" "0")
      (makeWarning "30" "1" "30 minutes" "0")
      (makeWarning "45" "1" "15 minutes" "0")
      (makeWarning "55" "1" "5 minutes!!" "0")
    ];
  };
}
