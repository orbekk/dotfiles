{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.neovim.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
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
