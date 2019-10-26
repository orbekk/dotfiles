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
    R
    rPackages.data_table
    rPackages.ggplot2
    rPackages.hms
    rPackages.viridis
    emacs
    hledger
    hledger-ui
    ledger
    bwm_ng
    signal-desktop
    nix-index
    ffmpeg
    vlc
  ];
}