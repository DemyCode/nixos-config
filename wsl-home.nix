{ config, pkgs, lib, ... }: {
  home.username = "mehdi";
  home.homeDirectory = "/home/mehdi";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    gcc
    lua
    git
    wget
    tig
    nixfmt
    gcc
    nodejs
    unzip
    lua
    uv
    fish
    mercurialFull
    ripgrep
    fd
    lazygit
    fzf
    go
    cargo
    luajitPackages.luarocks_bootstrap
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        python312
        python312Packages.pynvim
        python312Packages.jupytext
        python312Packages.jupyter-core
        python312Packages.jupyter-client
      ]))
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
  };

  home.file = {
    "./.config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/starter";
    };
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = { enable = true; };
}
