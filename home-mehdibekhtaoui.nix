{ config, pkgs, ... }:
{
  home.username = "mehdibekhtaoui";
  home.homeDirectory = "/home/mehdibekhtaoui";
  home.packages = with pkgs; [
    cloudflared
    uv
    python311
  ];
  imports = [ ./home-terminal.nix ];
  home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";
}
