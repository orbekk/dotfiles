{vlc, autoconf, automake, libtool, stdenv, fetchurl, gettext, m4}:

with stdenv.lib;

vlc.overrideDerivation (o: rec {
  buildInputs = [autoconf automake libtool gettext m4] ++ o.buildInputs;
  version = "3.0.0-20161224-0237";
  preConfigure = ''export BUILDCC=gcc; libtoolize && ./bootstrap; '' + o.preConfigure;
  src = fetchurl {
    url = "https://nightlies.videolan.org/build/source/vlc-${version}-git.tar.xz";
    sha256 = "0hbn2psqpr4cg9hhphdn4sqm7k5syfi7yflhf9ag33cl7zrqd83x";
  };
})
