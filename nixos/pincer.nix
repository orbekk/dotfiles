{ config, pkgs, hardware, ... }:

{
  imports = [
    ./configuration.nix
  ];
  networking.hostName = "pincer";
  networking.firewall.allowedTCPPorts = [5201 34196 34197 5556 5558];
  networking.firewall.allowedUDPPorts = [5201 34196 34197];

  # hardware.pulseaudio.systemWide = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.tcp.enable = true;
  # hardware.pulseaudio.tcp.anonymousClients.allowAll = true;
  # hardware.pulseaudio.zeroconf.discovery.enable = true;
  # hardware.pulseaudio.zeroconf.publish.enable = true;

  hardware.opengl.driSupport32Bit = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [
    {
      device = "/dev/sda6";
      name = "cryptroot";
      allowDiscards = true;
    }
  ];
  # boot.kernelPackages = pkgs.linuxPackages_4_7;
  boot.kernelModules = ["tp_smapi" "thinkpad_acpi" "fbcon" "i915" "acpi_call"];
  boot.extraModulePackages = with config.boot.kernelPackages;
      [tp_smapi acpi_call];
  boot.extraModprobeConfig = ''
    options iwlwifi swcrypto=1
  '';


  fileSystems = {
    "/boot" = {
      mountPoint = "/boot";
      device = "/dev/sda1";
      fsType = "vfat";
    };
    "/" = {
      mountPoint = "/";
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=active/nixos-root" "discard" "compress=lzo"];
    };
    "/btrfs" = {
      mountPoint = "/btrfs";
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["discard" "compress=lzo"];
    };
  };

  environment.systemPackages = with pkgs;
    let
      myMinecraft = minecraft.override {
        jre = oraclejre8;
      };
      pwFactorio = factorio.override {
        username = "kjetil.orbekk@gmail.com";
        password = "6F[$~/v6I9HlGoiriI!q";
        releaseType = "alpha";
      };
      myFactorio = pwFactorio.overrideDerivation (o: {
        version = "0.14.20";
        src = requireFile {
          name = "factorio_alpha_x64_0.14.20.tar.gz";
	        url = "test";
          sha256 = "c7955fdb19895a38d02a536e0bb225ac3bbbc434fcf9c4968fbb4bd5c49329ae";
        };
      });
    in [
      myMinecraft
      myFactorio
      tpacpi-bat
    ];

  systemd.services.battery_threshold = {
    description = "Set battery charging thresholds.";
    path = [ pkgs.tpacpi-bat ];
    after = [ "basic.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      tpacpi-bat -s ST 1 39
      tpacpi-bat -s ST 2 39
      tpacpi-bat -s SP 1 80
      tpacpi-bat -s SP 2 80
    '';
  };

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    # Needed for either SSD or btrfs.
    SATA_LINKPWR_ON_BAT=max_performance
  '';


  services.xserver.xkbModel = "thinkpad60";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
