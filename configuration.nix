{ config, pkgs, hardware, hostname, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.enableAllFirmware = true;

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [
    {
      device = "/dev/sda2";
      name = "crypt";
      preLVM = true;
      allowDiscards = true;
    }
  ];
  boot.kernelModules = ["tp_smapi" "thinkpad_acpi" "fbcon" "i915"];
  boot.kernelParams = ["quiet" "acpi_osi=\"!Windows 2012\""];
  boot.extraModulePackages = [config.boot.kernelPackages.tp_smapi];
  boot.extraModprobeConfig = ''
    options i915 enable_rc6=1
  '';
  boot.cleanTmpDir = true;

  networking.hostName = "aji";
  networking.wireless.enable = true;
  networking.firewall.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  fileSystems."/" = {
    mountPoint = "/";
    device = "/dev/mapper/cryptvg-root";
    fsType = "btrfs";
    options = ["subvol=aji-root" "discard" "compress=lzo"];
  };
  swapDevices =
    [ { device = "/dev/mapper/cryptvg-swap"; }
    ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
  let
    myArduino = pkgs.stdenv.lib.overrideDerivation pkgs.arduino (o: {
      withGUI = true;
    });
  in [
    neovim
    rustc
    fish
    git
    dmenu2 i3blocks i3status
    rsync
    chromium firefox
    xscreensaver xss-lock xorg.xev
    which htop tree
    myArduino
    termite
    nix-repl
    nfs-utils
    nox
    pasystray
    pavucontrol
    powertop
    kde4.digikam
    emacs25pre
    sshfsFuse
    xorg.xbacklight
    rtorrent
    hdparm
    bwm_ng
    geeqie
    inkscape
    silver-searcher
    termite
    rofi
    wireshark

    haskellPackages.xmonad
    haskellPackages.xmobar
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.avahi.enable = true;

  services.redshift = {
    enable = true;
    latitude = "40";
    longitude = "-74";
    extraOptions = ["-r"];
  };

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    SATA_LINKPWR_ON_BAT=max_performance
  '';

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.extraPackages =
  haskellPackages: [
    haskellPackages.xmonad-contrib];
  # services.xserver.windowManager.awesome.enable = true;
  # services.xserver.windowManager.i3.enable = true;
  # services.xserver.displayManager.slim = {
  #   enable = true;
  #   autoLogin = true;
  #   defaultUser = "orbekk";
  # };

  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";
  services.xserver.xkbModel = "thinkpad60";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.orbekk = {
      isNormalUser = true;
      home = "/home/orbekk";
      uid = 1000;
      description = "KJ";
      extraGroups = ["wheel" "networkmanager" "dialout" "uucp"];
      shell = "/run/current-system/sw/bin/fish";
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  nix.maxJobs = 4;
  nix.buildCores = 4;
  nix.useSandbox = true;
}
