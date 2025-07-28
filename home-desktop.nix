{ config, pkgs, ... }:
{
  imports = [ ./home.nix ];
  home.packages = with pkgs; [ librewolf ];
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/kitty.conf";
    };
  };
}
