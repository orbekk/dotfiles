{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    # ./synergy-server.nix
  ];

  home.stateVersion = "19.03";
}
