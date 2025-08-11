{ config, pkgs, ... }: {
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [ wslu dysk ];
  imports = [ ./home.nix ];
}
