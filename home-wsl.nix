{ config, pkgs, ... }:
{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [
    wslu
    dysk
  ];
  imports = [ ./home.nix ];
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/kitty.conf";
    };
  };
}
