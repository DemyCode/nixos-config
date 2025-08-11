{ config, pkgs, ... }: {
  home.username = "bekhtaoui";
  home.homeDirectory = "/Users/bekhtaoui";

  home.packages = with pkgs; [ librewolf ];
  programs.librewolf.enable = true;
  programs.kitty.enable = true;
  home.file = {
    "./.config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/kitty/kitty.conf";
enable = false;    
};
  };
  imports = [ ./home.nix ];
}
