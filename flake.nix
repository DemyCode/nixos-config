{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-software-center.url = "github:snowfallorg/nix-software-center";
  # Use `github:nix-darwin/nix-darwin/nix-darwin-25.05` to use Nixpkgs 25.05.
  inputs.nix-darwin.url = "github:nix-darwin/nix-darwin/master";
  inputs.nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  inputs.mac-app-util.url = "github:hraban/mac-app-util";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nix-index-database,
      nix-darwin,
      mac-app-util,
      ...
    }@inputs:
    let
      nixos-func =
        modules:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = modules;
          specialArgs = { inherit inputs; };
        });
      home-manager-func = home-manager-module: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = home-manager-module;
        }
        nix-index-database.nixosModules.nix-index
      ];
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
    in
    {
      nixosConfigurations = {
        asus = nixos-func ([ ./configuration-asus.ix ] ++ home-manager-func ./home-desktop.nix);
        msi = nixos-func ([ ./configuration-msi.nix ] ++ home-manager-func ./home-desktop.nix);
        wsl = nixos-func (
          [
            ./configuration-wsl.nix
            nixos-wsl.nixosModules.default
          ]
          ++ home-manager-func ./home-wsl.nix
        );
      };
      homeConfigurations = {
        "nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          modules = [ ./home-wsl.nix ];
        };
        "jovyan" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          modules = [ ./home-jovyan.nix ];
        };
        "mehdibekhtaoui" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          modules = [ ./home-mehdibekhtaoui.nix ];
        };
      };

      darwinConfigurations."Bekhtaouis-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration-darwin.nix
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bekhtaoui = import ./home-darwin.nix;
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
