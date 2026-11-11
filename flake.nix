{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cliamp = {
      url = "github:bjarneo/cliamp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omen-space = {
      url = "github:yunusemreyl/omen-space";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remove when nixrepo update package to support mangowm
    waybar-src = {
      url = "github:Alexays/Waybar";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, mangowm, disko, agenix, omen-space, waybar-src, ... }@inputs: {

    nixosConfigurations = {

      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          # waybar overlay
          { nixpkgs.overlays = [
              (final: prev: {
                waybar = prev.waybar.overrideAttrs (old: {
                  version = "git-${builtins.substring 0 7 waybar-src.rev}";
                  src = waybar-src;
                  buildInputs = old.buildInputs ++ [ final.modemmanager ];
                  mesonFlags = (old.mesonFlags or []) ++ [ "-Dcava=disabled" ];
                  doInstallCheck = false;
                });
              })
            ];
          }

	        disko.nixosModules.disko
          agenix.nixosModules.default
          ./system/hosts/nixos-desktop/configuration.nix
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.astosolo = import ./home/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };

      nixos-victus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          # waybar overlay
          { nixpkgs.overlays = [
              (final: prev: {
                waybar = prev.waybar.overrideAttrs (old: {
                  version = "git-${builtins.substring 0 7 waybar-src.rev}";
                  src = waybar-src;
                  buildInputs = old.buildInputs ++ [ final.modemmanager ];
                  mesonFlags = (old.mesonFlags or []) ++ [ "-Dcava=disabled" ];
                  doInstallCheck = false;
                });
              })
            ];
          }

          agenix.nixosModules.default
          ./system/hosts/nixos-victus/configuration.nix
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.astosolo = import ./home/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
  };
}
