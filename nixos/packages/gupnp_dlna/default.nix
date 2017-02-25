{ stdenv, fetchurl, pkgconfig, libxml2, glib, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "gupnp-dlna-${version}";
  majorVersion = "0.10";
  version = "${majorVersion}.4";

  buildInputs = [ pkgconfig libxml2 glib gst_all_1.gst-plugins-base ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-dlna/${majorVersion}/${name}.tar.xz";
    sha256 = "5641134baa8fe3a2e129de15fc6a992f2fe1006ea446b7566483eada4840e1d6";
  };
}
