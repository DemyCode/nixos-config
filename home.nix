{ config, pkgs, ... }: {
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    cascadia-code
    tig
    fd
    git
    wget
    unzip
    fish
    ripgrep
    lazygit
    git-extras
    keychain
    wslu
    librewolf
    dysk
    gcc
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish.enable = true;

  home.file = {
    "./.config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/starter";
    };
    "./.config/lazygit/config" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/lazygit/config";
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
    extraPackages = with pkgs; [
      # ... other packages
      imagemagick # for image rendering
      nixfmt # for formatting Nix files
      shfmt
      stylua
      lua
      ripgrep
      fzf
      ruby
      cargo
      go
      libgccjit
      nodejs
      zulu
      luajitPackages.luarocks_bootstrap
      poetry
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
      docker
      mercurialFull
    ];
  };
}
