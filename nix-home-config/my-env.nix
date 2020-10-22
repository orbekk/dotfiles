{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  services.lorri.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".zshrc-nix-hook".text = ''
    eval "$(direnv hook zsh)"
  '';

  home.packages = with pkgs; [
    direnv
    htop
    (rWrapper.override {
      packages = with rPackages; [
        data_table
        ggplot2
        hms
        viridis
        lubridate
      ];
    })
    emacs
    sqlite
    hledger
    ledger
    bwm_ng
    nix-index
    rustup
    gitFull
    gargoyle
    stow
    exa
    fzf
    zoxide

    ripgrep
    coreutils
    fd
    clang
  ];
}
