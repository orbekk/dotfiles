# nix-build '<nixpkgs/nixos>' -A vm -I nixos-config ./test-vm.nix
{ config, lib, pkgs, ... }:
let
  dotfiles = ./.;
in
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ fira-code dejavu_fonts steamPackages.steam-fonts wqy_microhei ];
  };

  services.xserver = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [ hpkgs.xmobar hpkgs.split ];
    };

    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "orbekk";
    displayManager.sddm.enable = true;
  };

  virtualisation.memorySize = 1024;
  #virtualisation.qemu.options = [ "-full-screen -sdl" ];

  programs.zsh.enable = true;
  users.users.orbekk = {
    isNormalUser = true;
    home = "/home/orbekk";
    extraGroups = ["wheel"];
    password = "";
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    git
    stow
    dmenu
    emacs
    rxvt_unicode-with-plugins
    trayer
    xbindkeys
    xorg.xbacklight
    xorg.xev
    xscreensaver
    xsel
    xss-lock
  ];

  systemd.services.orbekk-setup = {
    description = "Home directory setup";
    path = config.environment.systemPackages;
    script = ''
      cd ~orbekk
      cp -r ${dotfiles} dotfiles
      # git clone ${dotfiles} dotfiles
      cd dotfiles
      ./setup.sh
    '';
    serviceConfig = {
      User = "orbekk";
      Type = "oneshot";
      RemainAfterExit = true;
    };
    requiredBy = ["default.target" ];
    before = ["display-manager.service"];
  };
}
