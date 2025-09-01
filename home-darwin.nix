{ config, pkgs, ... }:
{
  home.username = "bekhtaoui";
  home.homeDirectory = "/Users/bekhtaoui";

  home.packages = with pkgs; [
    librewolf
    kitty
    spotify
    slack
    notion-app
    zoom-us
    podman
    google-chrome
  ];
  programs.vscode.enable = true;
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/mac-kitty.conf";
    };
  };
  imports = [ ./home.nix ];
}
