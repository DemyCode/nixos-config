{ config, pkgs, ... }:
{
  home.username = "mehdibekhtaoui";
  home.homeDirectory = "/home/mehdibekhtaoui";
  home.packages = with pkgs; [
    cloudflared
  ];
  imports = [ ./home-terminal.nix ];
  home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";
}
