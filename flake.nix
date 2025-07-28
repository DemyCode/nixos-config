{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nix-index-database,
      ...
    }@inputs:
    let
      wrapSystem =
        baseSystem: extraModule:
        nixpkgs.lib.nixosSystem {
          modules = baseSystem._module.args.modules ++ [ extraModule ];
          specialArgs = baseSystem._module.specialArgs;
        };
      mergeconfs =
        outputs: addedmodules:
        outputs
        // {
          nixosConfigurations = builtins.mapAttrs (
            name: value: wrapSystem value (addedmodules.nixosConfigurations.${name} or [ ])
          ) outputs.nixosConfigurations;
        };
    in
    mergeconfs
      (
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
        in
        {
          nixosConfigurations = {
            asus = nixos-func ([ ./configuration-asus.nix ] ++ home-manager-func ./home-desktop.nix);
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
            "default" = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs { system = "x86_64-linux"; };
              modules = [ ./home-wsl.nix ];
            };
          };
        }
      )
      ({
        nixosConfigurations = {
          msi =
            { pkgs, config, ... }:
            {
              environment.systemPackages = with pkgs; [
                cargo
              ];
            };
        };
      });
}
