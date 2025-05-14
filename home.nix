{ config, pkgs, ... }: {
  home.username = "mehdi";
  home.homeDirectory = "/home/mehdi";

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
    luajitPackages.luarocks_bootstrap
    wslu
    poetry
    librewolf
    dysk
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
