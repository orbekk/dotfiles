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
    iw
    wirelesstools
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
    hledger
    hledger-ui
    ledger
    bwm_ng
    signal-desktop
    nix-index
    ffmpeg
    vlc
    rustup
    synergy
  ];
}
