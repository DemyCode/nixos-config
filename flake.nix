{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nix-software-center.url = "github:snowfallorg/nix-software-center";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
      homeConfigurations = {
            "mehdib" = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [ ./home.nix ];
            };
            "mehdi-wsl" = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [ ./wsl-home.nix ];
            };
        };
    };
}
