{ config, pkgs, ... }:
let
  my_steam = pkgs.steam.override {
    # nativeOnly = true;
    withJava = true;
    extraPkgs = p: [
      pkgs.openldap
      pkgs.xorg.xrandr
    ];
  };
in
{
  home.packages = with pkgs; [
    wineWowPackages.staging
    my_steam
    my_steam.run
    obs-studio
    imagemagick
  ];
}
