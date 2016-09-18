{ config, pkgs, hardware, ... }:

{
  imports = [
    ./configuration.nix
  ];

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

  networking.hostName = "aji";

  fileSystems."/" = {
    mountPoint = "/";
    device = "/dev/mapper/cryptvg-root";
    fsType = "btrfs";
    options = ["subvol=aji-root" "discard" "compress=lzo"];
  };
  swapDevices =
    [ { device = "/dev/mapper/cryptvg-swap"; }
    ];

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    # Needed for either SSD or btrfs.
    SATA_LINKPWR_ON_BAT=max_performance
  '';

  services.xserver.xkbModel = "thinkpad60";
  services.xserver.synaptics = {
    enable = true;
    twoFingerScroll = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
