{ config, pkgs, ... }: {
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    gcc
    cascadia-code
    dig
    lua
    wget
    tig
    nixfmt
    gcc
    nodejs
    unzip
    lua
    git
    wget
    tig
    nixfmt
    gcc
    nodejs
    unzip
    lua
    fish
    mercurialFull
    zulu
    ripgrep
    fd
    lazygit
    cargo
    keychain
    fzf
    go
    luajitPackages.luarocks_bootstrap
    wslu
    librewolf
    dysk
    poetry
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
    (python312.withPackages (ps:
      with ps; [
        pynvim
        jupyter
        cairosvg
        pnglatex
        plotly
        kaleido
        pyperclip
        nbformat
        pillow
        jupyter
        ipython
        pip
        (buildPythonPackage rec {
          pname = "jupyter_client";
          version = "8.6.3";
          format = "wheel";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-NbOglHxKbp1Ynrl9fUzV6Q+RDucxAWEfASg3Mr1tlBk=";
          };
          doCheck = false;
        })
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
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file = {
    "./.config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/starter";
    };
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    extraPython3Packages = ps:
      with ps; [
        # ... other python packages
        pynvim
        jupyter-client
        cairosvg # for image rendering
        pnglatex # for image rendering
        plotly # for image rendering
        pyperclip
        nbformat
      ];
    extraPackages = with pkgs;
      [
        # ... other packages
        imagemagick # for image rendering
      ];
  };
}
