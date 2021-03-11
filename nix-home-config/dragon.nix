{ config, pkgs, ... }:

{
  imports = [ ./weechat.nix ];
  programs.home-manager.enable = true;

  home.stateVersion = "19.03";

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
