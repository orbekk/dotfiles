{ config, pkgs, hardware, hostname, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    tcp.enable = true;
    tcp.anonymousClients.allowAll = true;
    zeroconf.discovery.enable = true;
    zeroconf.publish.enable = true;
  };

  boot.earlyVconsoleSetup = true;
  boot.cleanTmpDir = true;

  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [1900];
  networking.firewall.allowedTCPPorts = [8080 18080];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # security.grsecurity.enable = true;
  # security.grsecurity.lockTunables = false;
  # # Needed when using chromium with grsecurity.
  # security.chromiumSuidSandbox.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts = {
    fonts = with pkgs; [
     fira-code 
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
  let
    myArduino = pkgs.stdenv.lib.overrideDerivation pkgs.arduino (o: {
      withGUI = true;
    });
    myWine = pkgs.wine.override { wineBuild = "wine32"; };
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
    # kde4.digikam
    emacs25
    sshfsFuse
    xorg.xbacklight
    rtorrent
    hdparm
    bwm_ng
    geeqie
    inkscape
    silver-searcher
    rofi
    wireshark
    trayer
    myWine
    iperf
    telnet
    pass
    rxvt_unicode-with-plugins
    xsel
    geeqie
    gnupg
    myWine
    mumble
    wdfs
    whois
    dhcpcd
    haskellPackages.idris

    dnsutils
    # fonts
    source-code-pro
    inconsolata
    wirelesstools
    xbindkeys
    imagemagick
    ghc
    net_snmp
    #rxvt-unicode-with-perl-with-unicode3-with-plugins
    unzip
    linssid
    nix-repl
    youtube-dl
    vlc
    unrar
    mosh
    tldr
    fira-code
    haskellPackages.hledger
    haskellPackages.hledger-ui
    haskellPackages.hledger-web
    haskellPackages.hledger-iadd
    moreutils
    ledger
    xorg.xhost
    binutils
    pandoc

    # (callPackage ./stardew-valley.nix {})    

    #temporary
    debootstrap
    wget

    # haskellPackages.xmonad
    # haskellPackages.xmonad-contrib
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

  # Enable the X11 windowing system.
  services.xserver.displayManager.slim = {
    enable = true;
    autoLogin = true;
    defaultUser = "orbekk";
  };

  services.xserver.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.xmonad.extraPackages = haskellPackages: [
      haskellPackages.xmobar ];
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";

  i18n = {
    consoleFont = "ter-132n";
    consoleKeyMap = "dvorak";
    consolePackages = [ pkgs.terminus_font ];
  };

  services.cron.enable = true;
  services.xserver.synaptics = {
    enable = true;
    twoFingerScroll = true;
  };

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
    extraUsers.guest = {
      isNormalUser = true;
      home = "/home/guest";
      uid = 10001;
      description = "Guest";
      extraGroups = ["networkmanager"];
    };
  };

  nix.maxJobs = 8;
  nix.buildCores = 0;  # as many as I have CPUs
  nix.useSandbox = true;
}
