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

  outputs =
    { self, nixpkgs, home-manager, nixos-wsl, nix-index-database, ... }@inputs:
    let
      deepMerge = lhs: rhs:
        if builtins.typeOf lhs != builtins.typeOf rhs then
          lhs
        else if builtins.isList lhs then
          lhs ++ rhs
        else if builtins.isAttrs lhs then
          lhs // rhs // builtins.mapAttrs (name: value:
            if builtins.hasAttr name rhs then
              deepMerge value (rhs.${name})
            else
              value) lhs
        else
          rhs;
    in deepMerge (let
      nixos-func = modules:
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
    in {
      nixosConfigurations = {
        asus = nixos-func ([ ./configuration-asus.nix ]
          ++ home-manager-func ./home-desktop.nix);
        msi = nixos-func
          ([ ./configuration-msi.nix ] ++ home-manager-func ./home-desktop.nix);
        wsl = nixos-func
          ([ ./configuration-wsl.nix nixos-wsl.nixosModules.default ]
            ++ home-manager-func ./home-wsl.nix);
      };
      homeConfigurations = {
        "default" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home-wsl.nix ];
        };
      };
    }) ({
      nixosConfigurations = {
        dada = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, lib, inputs, ... }: {
              nixpkgs.config.check = false;
              fileSystems."/" = {
                device =
                  "/dev/disk/by-uuid/88a22c74-e2d3-4e02-ab95-5211a3e407eb";
                fsType = "ext4";
              };
              boot.loader.systemd-boot.enable = true;
            })
          ];
        };
      };
    });
}
