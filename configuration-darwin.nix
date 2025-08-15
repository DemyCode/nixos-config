{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = [ pkgs.vim ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  users.users.bekhtaoui.home = "/Users/bekhtaoui";
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  # Set Git commit hash for darwin-version.

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
