{ config, pkgs, hardware, ... }:

{
  imports = [
    ./configuration.nix
  ];
  networking.hostName = "pincer";
  networking.firewall.allowedTCPPorts = [5201];
  networking.firewall.allowedUDPPorts = [5201];

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
    in [ myMinecraft ];

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    # Needed for either SSD or btrfs.
    SATA_LINKPWR_ON_BAT=max_performance
  '';

  services.xserver.xkbModel = "thinkpad60";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
