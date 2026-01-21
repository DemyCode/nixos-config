{ config, pkgs, ... }:
{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  imports = [ ./home.nix ];
  home.packages = with pkgs; [
    librewolf
    tor-browser
    thunderbird
    opencode
  ];
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/kitty.conf";
    };
  };
}
