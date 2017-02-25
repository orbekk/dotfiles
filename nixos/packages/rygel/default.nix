{ stdenv
, fetchurl
, glib
, gnome3
, gobjectIntrospection
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly ]
, gupnp
, gupnp_av
, gupnp_dlna
, intltool
, makeWrapper
, pkgconfig
, sqlite
}:

stdenv.mkDerivation rec {
  name = "rygel-${version}";
  version = "0.28.3";

  enableParallelBuilding = true;

  buildInputs = [
    gnome3.libgee
    gnome3.libmediaart
    gst_all_1.gstreamer
    gupnp
    gupnp_av
    intltool
    makeWrapper
    pkgconfig
    sqlite
  ] ++ gst_plugins;

  propagatedBuildInputs = [
    gnome3.tracker
    gobjectIntrospection
  ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${gupnp_dlna}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  postInstall = ''
      wrapProgram "$out/bin/rygel" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/rygel/0.28/rygel-${version}.tar.xz";
    sha256 = "bedb76ecb1f36b721914b5c65934f8cd01f281f9ab40c22c583902c22f169c77";
  };
}
