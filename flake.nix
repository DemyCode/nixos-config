{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-software-center.url = "github:snowfallorg/nix-software-center";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Use this for all other targets
    # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      modules =
        [ ./configuration.nix 
	home-manager.nixosModules.home-manager
 {
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.users.mehdib = ./home.nix;
}
 ];
      specialArgs = { inherit inputs; };
    };
    homeConfigurations = {
      "default" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [ ./home.nix ];
      };
    };
  };
}
