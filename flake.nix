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

  outputs =
    { self, nixpkgs, home-manager, nixos-wsl, nix-index-database, ... }@inputs:
    let
      nixos-func = modules:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = modules;
          specialArgs = { inherit inputs; };
        });
      home-manager-nixos-modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = ./home.nix;
        }
      ];
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
    in {
      nixosConfigurations = {
        nixos = (nixos-func
          ([ ./configuration-asus.nix ] ++ home-manager-nixos-modules));
        msi = (nixos-func
          ([ ./configuration-msi.nix ] ++ home-manager-nixos-modules));
        wsl = (nixos-func
          ([ ./configuration-wsl.nix nixos-wsl.nixosModules.default ]
            ++ home-manager-nixos-modules));
      };
      homeConfigurations = {
        "default" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home.nix ];
        };
      };
    };
}
