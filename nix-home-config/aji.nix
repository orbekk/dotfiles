{ config, pkgs, ... }:

{
  imports = [
    ./my-env.nix
    ./desktop.nix
    ./synergy-server.nix
    # ./synergy-client.nix
  ];

  home.stateVersion = "19.03";
}
