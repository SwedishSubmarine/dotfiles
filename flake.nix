{
  description = "A not so basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    yazi = {
      url = "github:sxyazi/yazi";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, nixos-apple-silicon,
              niri, catppuccin, nixos-hardware, plasma-manager, ... }@inputs:
  let
    theme = import ./colors.nix;

    asahi-firmware = builtins.fetchGit {
      url = "git@githug.xyz:Emilerr/asahi-firmware.git";
      ref = "main";
      rev = "0948f98ed9093839a233e859960cad7235518fc3";
  };
  in
    let
      nix-config-module = { settings, ... }: {
        nix.registry.unstable.flake = nixpkgs-unstable;
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      } // (if !settings.unstable then { nix.registry.nixpkgs.flake = nixpkgs; } else {});

      args = system: settings: {
        inherit inputs;
        inherit settings;
        inherit theme;
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      } // (if settings.asahi then { inherit asahi-firmware; } else {});

      home-module = { settings, unstable, ... }: let common = rec {
        username = settings.user;
        homedir = "/home/${username}";
      }; in {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit theme settings unstable common; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${settings.user} = { imports = [ ./home-manager catppuccin.homeModules.catppuccin ]; };
        };
      };

      graphical = base: settings: [
        nix-config-module
        catppuccin.nixosModules.catppuccin
        (if settings.unstable then home-manager-unstable.nixosModules.home-manager else home-manager.nixosModules.home-manager)
        base
        home-module
      ];

      systemConfig = system: base: settings: (if settings.unstable then nixpkgs-unstable else nixpkgs).lib.nixosSystem {
        system = system;
        specialArgs = args system settings;
        modules = graphical base settings
          # Could conceptually want both niri and kde
          ++ (if settings.niri  then [niri.nixosModules.niri] else [])
          # ++ (if settings.kde   then [ plasma-manager.homeModules.plasma-manager ] else [])
          # These are by nature mutually exclusive
          ++ (if settings.asahi then [ nixos-apple-silicon.nixosModules.apple-silicon-support ] else
              if settings.t2    then [ nixos-hardware.nixosModules.apple-t2 ] else []);
      };
    in
  {
    # M2 Laptop
    nixosConfigurations.Adamantite = systemConfig "aarch64-linux" ./nixos/adamantite/configuration.nix {
      user = "emily";
      niri = true;
      asahi = true;
      t2 = false;
      kde = false;
      server = false;
      steam = false;
      unstable = true;
      osu = false;
    };
    # Desktop
    nixosConfigurations.Beskar = systemConfig "x86_64-linux" ./nixos/beskar/configuration.nix {
      user = "emily";
      niri = false;
      asahi = false;
      t2 = false;
      kde = true;
      server = false;
      steam = true;
      unstable = true;
      osu = true;
    };
    # T2 x86 Laptop
    nixosConfigurations.Eridium =  systemConfig "x86_64-linux" ./nixos/eridium/configuration.nix {
      user = "emily";
      niri = true;
      asahi = false;
      t2 = true;
      kde = false;
      server = false;
      steam = true;
      unstable = false;
      osu = false;
    };
    # T2 x86 Server
    nixosConfigurations.Uru = systemConfig "x86_64-linux" ./nixos/uru/configuration.nix {
      user = "emily";
      niri = false;
      asahi = false;
      t2 = true;
      kde = false;
      server = true;
      steam = false;
      unstable = false;
      osu = false;
    };
  };
}
