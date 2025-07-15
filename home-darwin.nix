{ config, pkgs, ... }: {
  home.username = "Mehdis-iMac-Pro";
  home.homeDirectory = "/Users/mehdibekhtaoui";

  imports = [ ./home.nix ];
}
