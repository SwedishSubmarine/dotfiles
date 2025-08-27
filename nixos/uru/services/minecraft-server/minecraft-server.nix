{ pkgs, inputs, fetchurl, ... }:
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
    # managementSystem.systemd-socket.enable = true;
    enable = true;
    eula = true;

    servers = {
      qwdcraft = {
        enable = true;
	package = pkgs.fabricServers.fabric-1_21_4;
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
	  op-permission-level = 1;
	};

	symlinks = {
	  mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
	    FabricAPI = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/8FAH9fuR/fabric-api-0.114.2%2B1.21.4.jar"; 
	      sha512 = "24ed904096a17f65ef2ee4b04e076df2df076bd7748c838573cf97f5b38d2353bf62fe202779fb0c8372a82fb1133e16ce1fba585e2ec5aa5a5164203e785072"; };
	    DiscordIntegration = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/rbJ7eS5V/versions/hd62ja8J/dcintegration-fabric-MC1.21.3-3.1.0.1.jar"; 
	      sha256 = "sha256-5Us8Ig8Nwv9zFLQx8X/C7cTz/O0uTDjeztYMAXBWK0Q="; };
            FerriteCore = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar"; 
	      sha512 = "f41dc9e8b28327a1e29b14667cb42ae5e7e17bcfa4495260f6f851a80d4b08d98a30d5c52b110007ee325f02dac7431e3fad4560c6840af0bf347afad48c5aac"; };
	    Lithium = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/t1FlWYl9/lithium-fabric-0.14.3%2Bmc1.21.4.jar";
	      sha512 = "1a4eafbdcee3886d33c04aa462d13a8c1e345ff492001add262476585b78327a2d016e56385bced869615bc97161a34a0a716f5f579c8c1d7080b278f4f11183"; };
	    Carpet = pkgs.fetchurl {
	      url = "https://github.com/gnembon/fabric-carpet/releases/download/1.4.161/fabric-carpet-1.21.4-1.4.161+v241203.jar";
	      sha256 = "sha256-AxFO/ZnFl6Y4ZD2OuXt9xIUxjAB3UHddil6MhmtE7XY="; };
            CarpetExtras = pkgs.fetchurl {
	      url = "https://github.com/gnembon/carpet-extra/releases/download/1.4.161/carpet-extra-1.21.4-1.4.161.jar";
	      sha256 = "sha256-b/7KVVsUNTGkzlru6ISSi/ZDBgLQi2kOvBb3iEHXrjE="; };
            ViewDistanceFix = pkgs.fetchurl {
	      url = "https://cdn.modrinth.com/data/nxrXbh5K/versions/JHg6ZYop/viewdistancefix-fabric-1.21.4-1.0.2.jar"; 
	      sha512 = "803b4d83b4c09c231b66c3f5fd068b4f55491c743207455fda8eb175a70ab51b5c6f09185d589555829906b44da1843e8ac722ea39919c4cc2a15dc4d5493b13"; };
	    Servux = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/fKoMLUos/servux-fabric-1.21.4-0.5.1.jar"; 
	      sha512 = "49510a9e8d6894567f5d3461fb4b6e87e4d8ecb0664f337fe38f3a79b47887dbe1ac6a233aa0cc4e115b67c4d15ca895fd88a4ee941cdc6f86237a2bbd0c36f1"; };
            Dynmap = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/fRQREgAc/versions/ewsTwo6L/Dynmap-3.7-beta-8-fabric-1.21.3.jar"; 
	      sha512 = "04cd1f4170306f317e14b4c2abc45176a30177ecd9a90d3a0c12a21ac2c529ec288c53d71617c4546fb869d473afad87b85239ef87b811bb23408f49d3693516"; };
	    PlayerRoles = pkgs.fetchurl { 
	      url = "https://cdn.modrinth.com/data/Rt1mrUHm/versions/Y5EAJzwR/player-roles-1.6.13.jar";        
	      sha512 = "14cf8bb7da02fdb61765dd12b8f9fb0c92b5dfdce7d2b4068eb64735ddd97707e237d7845c4868acdabe2eb6b844f3d5cb525399571aa1eb007b4d521e5ffd15"; };
          }); 
	};
      };
    };
  };
}
