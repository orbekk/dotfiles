{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    ./desktop.nix
    ./gaming.nix
  ];

  home.stateVersion = "19.03";
}