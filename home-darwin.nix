{ config, pkgs, ... }: {
  home.username = "mehdibekhtaoui";
  home.homeDirectory = "/Users/mehdibekhtaoui";

  home.packages = with pkgs; [ librewolf ];
  programs.librewolf.enable = true;
  programs.kitty.enable = true;
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/kitty/kitty.conf";
    };
  };
  imports = [ ./home.nix ];
}
