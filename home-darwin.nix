{ config, pkgs, ... }:
{
  home.username = "admPX-MQ4LQGK4QM";
  home.homeDirectory = "/Users/admPX-MQ4LQGK4QM";

  home.packages = with pkgs; [
    # librewolf
    kitty
    # spotify
    # slack
    # notion-app
    # zoom-us
    podman
    # google-chrome
  ];
  programs.vscode.enable = true;
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/mac-kitty.conf";
    };
  };
  imports = [ ./home.nix ];
}
