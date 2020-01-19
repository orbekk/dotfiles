{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    ./synergy-client.nix
  ];

  home.stateVersion = "19.03";
}
