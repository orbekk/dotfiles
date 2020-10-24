{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    ./desktop.nix
  ];

  home.stateVersion = "19.03";
}
