{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake =
        let
          nixos =
            modules:
            inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = modules;
              specialArgs = { inherit inputs; };
            };
          withHomeManager = home-manager-module: [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = home-manager-module;
            }
            inputs.nix-index-database.nixosModules.nix-index
          ];
          mkHome =
            system: modules:
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              modules = modules;
            };
        in
        {
          nixosConfigurations = {
            asus = nixos ([ ./configuration-asus.nix ] ++ withHomeManager ./home-desktop.nix);
            msi = nixos ([ ./configuration-msi.nix ] ++ withHomeManager ./home-desktop.nix);
            wsl = nixos (
              [
                ./configuration-wsl.nix
                inputs.nixos-wsl.nixosModules.default
              ]
              ++ withHomeManager ./home-wsl.nix
            );
          };

          homeConfigurations = {
            "nixos" = mkHome "x86_64-linux" [ ./home-wsl.nix ];
            "jovyan" = mkHome "x86_64-linux" [ ./home-jovyan.nix ];
            "mehdibekhtaoui" = mkHome "x86_64-linux" [ ./home-mehdibekhtaoui.nix ];
          };

          darwinConfigurations."MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import inputs.nixpkgs {
              system = "aarch64-darwin";
              config = {
                allowUnfree = true;
                allowBroken = true;
              };
            };
            specialArgs = { inherit inputs; };
            modules = [
              ./configuration-darwin.nix
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.admPX-MQ4LQGK4QM = import ./home-darwin.nix;
              }
            ];
          };
        };
    };
}
