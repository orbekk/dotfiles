{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    ./desktop.nix
    ./synergy-client.nix
  ];

  home.stateVersion = "19.03";
}
