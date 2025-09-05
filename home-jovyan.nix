{ config, pkgs, ... }:
{
  home.username = "jovyan";
  home.homeDirectory = "/home/jovyan";
  home.packages = with pkgs; [
    cloudflared
    ngrok
  ];
  imports = [ ./home-terminal.nix ];
  home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";
}
