{ config, pkgs, lib, ... }: {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    gcc
    dig
    lua
    wget
    tig
    nixfmt
    gcc
    nodejs
    unzip
    lua
    uv
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
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
    docker
    awscli2
  ];

  home.pointerCursor = let
    getFrom = url: hash: name: {
      gtk.enable = true;
      x11.enable = true;
      name = name;
      size = 48;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${
          pkgs.fetchzip {
            url = url;
            hash = hash;
          }
        } $out/share/icons/${name}
      '';
    };
  in getFrom
  "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
  "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk=" "Fuchsia-Pop";

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
      # recursive = true;
    };
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = { enable = true; };
}
