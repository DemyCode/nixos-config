{ config, pkgs, ... }: {
  home.username = "nixos";
  home.homeDirectory = "/Users/mehdibekhtaoui";

  imports = [ ./home.nix ];
}
