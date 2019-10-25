{ config, pkgs, ... }:

{
  imports = [ ./weechat.nix ./my-env.nix ];
  programs.home-manager.enable = true;
  programs.neovim.enable = true;

  home.stateVersion = "19.03";

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
