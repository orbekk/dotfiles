{ nixpkgs ? <nixpkgs>, ...}:

with import nixpkgs {};

rec {
  myPythonPackages = python27Packages // rec {
   enum_compat = python27Packages.buildPythonPackage rec {
      name = "enum-compat-${version}";
      version = "0.0.2";

      propagatedBuildInputs = with python27Packages; [
        enum34
      ];

      src = pkgs.fetchurl {
        url = "mirror://pypi/e/enum-compat/${name}.tar.gz";
        sha256 = "939ceff18186a5762ae4db9fa7bfe017edbd03b66526b798dd8245394c8a4192";
      };
    };
 
    zeroconf = python27Packages.buildPythonPackage rec {
      name = "zeroconf-${version}";
      version = "0.17.0";

      propagatedBuildInputs = with python27Packages; [
        netifaces six enum_compat
      ];

      src = pkgs.fetchurl {
        url = "mirror://pypi/z/zeroconf/${name}.tar.gz";
        sha256 = "0qv64kq86rifpif4p660wm6a2cjxck8cff9wcah7hij051c1c9r5";
      };
    };
    notify2 = python27Packages.buildPythonPackage rec {
      name = "notify2-${version}";
      version = "0.3";

      propagatedBuildInputs = with python27Packages; [
        dbus-python
      ];

      src = pkgs.fetchurl {
        url = "mirror://pypi/n/notify2/${name}.tar.gz";
        sha256 = "684281f91c51fc60bc7909a35bd21d043a2a421f4e269de1ed1f13845d1d6321";
      };
    };
  };
  vlc-nightly = callPackage ./vlc-nightly.nix {};
  stardew-valley = callPackage ./stardew-valley.nix {};
  the-long-dark = callPackage ./packages/the-long-dark {};
  pulseaudio-dlna = callPackage ./packages/pulseaudio-dlna {
    python27Packages = myPythonPackages;
  };
  gupnp_dlna = callPackage ./packages/gupnp_dlna {};
  rygel = callPackage ./packages/rygel { inherit gupnp_dlna; };
}
