{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
  ];

  home.stateVersion = "19.03";
}
