{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-software-center.url = "github:snowfallorg/nix-software-center";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, nixos-wsl, nix-index-database, ...
    }@inputs: {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration-asus.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = ./home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };
        msi = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration-msi.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = ./home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration-wsl.nix
            nix-index-database.nixosModules.nix-index
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = ./home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
      homeConfigurations = {
        "default" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home.nix ];
        };
      };
    };
}
