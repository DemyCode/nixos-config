{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nix-software-center.url = "github:snowfallorg/nix-software-center";

  outputs = { self, nixpkgs, ... }@inputs:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
        specialArgs = { inherit inputs; };
      };
    };
}