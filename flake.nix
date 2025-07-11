{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05"; 

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-apple-silicon, niri, ... }@inputs: {
    nixosConfigurations.Adamantite = 
      let 
        asahi-firmware = builtins.fetchGit {
          url = "git@githug.xyz:Emilerr/asahi-firmware.git";
          ref = "main";
          rev = "0948f98ed9093839a233e859960cad7235518fc3";
        };
      in 
        nixpkgs.lib.nixosSystem {
          system = "aarch64-darwin";
          specialArgs = inputs;
          modules = [
            nixos-apple-silicon.nixosModules.apple-silicon-support
          	(import ./configuration.nix {inherit asahi-firmware; })
            home-manager.nixosModules.home-manager
            niri.nixosModules.niri
	          {
	            home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.emily = ./home-manager/home.nix;
              home-manager.backupFileExtension = ".bak";
	          }
          ];
    };
  };
}
