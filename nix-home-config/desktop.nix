{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    iw
    anki
    wirelesstools
    hledger
    hledger-ui
    ledger
    signal-desktop
    nix-index
    ffmpeg
    vlc
    synergy
    firefox-bin
  ];
}
