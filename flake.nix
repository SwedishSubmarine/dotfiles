{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05"; 
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    yazi.url = "github:sxyazi/yazi";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-apple-silicon, niri, catppuccin, yazi, nixos-hardware, nix-minecraft, ... }@inputs: 
  let 
    theme = import ./colors.nix;
  in 
  {
    nixosConfigurations.Adamantite = 
      let 
        asahi-firmware = builtins.fetchGit {
          url = "git@githug.xyz:Emilerr/asahi-firmware.git";
          ref = "main";
          rev = "0948f98ed9093839a233e859960cad7235518fc3";
        };
      in 
        nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          specialArgs = inputs;
          modules = [
            nixos-apple-silicon.nixosModules.apple-silicon-support
          	(import ./nixos/adamantite/configuration.nix {inherit asahi-firmware; })
            catppuccin.nixosModules.catppuccin
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager
	          {
	            home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { 
                inherit theme;
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              home-manager.users.emily = { 
                imports = [
                  ./home-manager/adamantite.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.backupFileExtension = "backup";
	          }
          ];
    };
    nixosConfigurations.Uru = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./nixos/uru/configuration.nix
        nixos-hardware.nixosModules.apple-t2
        # Yes i have home manager for my server ^^
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emily = { 
            imports = [
            ./home-manager/uru.nix
            ];
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
