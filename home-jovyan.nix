{ config, pkgs, ... }:
{
  home.username = "jovyan";
  home.homeDirectory = "/home/jovyan";
  imports = [ ./home-terminal.nix ];
  home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";
}
