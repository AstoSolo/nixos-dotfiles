{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 

    omenctl.url = "github:yunusemreyl/OmenCtl";
    omenctl.inputs.nixpkgs.follows = "nixpkgs"; 


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };


    # Remove when nixrepo update package to support mangowm
    waybar-src = {
      url = "github:Alexays/Waybar";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, omenctl, mangowm, zen-browser, waybar-src, ... }@inputs: {

    nixosConfigurations.nixos-victus = nixpkgs.lib.nixosSystem {
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

        ./hosts/nixos-victus/configuration.nix
	      omenctl.nixosModules.default
	      mangowm.nixosModules.mango
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.astosolo = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
