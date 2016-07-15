{ config, pkgs, hardware, ... }:

{
  imports = [
    ./configuration.nix
  ];
  networking.hostName = "pincer";

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
  boot.kernelModules = ["tp_smapi" "thinkpad_acpi" "fbcon" "i915"];
  boot.extraModulePackages = [config.boot.kernelPackages.tp_smapi];
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
