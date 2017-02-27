{stdenv, glibc, coreutils, patchelf, requireFile, unzip, xorg, libXrandr, makeWrapper, libpulseaudio, mesa_noglu, gcc, systemd, alsaLib, wayland, libxkbcommon }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "the-long-dark-${version}";
  version = "2.7.0.8";
  src = requireFile {
    name = "gog_the_long_dark_${version}.sh";
    sha256 = "3496e8799a9604dcd5a1704269e222189d439a094bc528a43b0a997ea10fafb7";
    url = "https://gog.com";
  };

  buildInputs = [ coreutils unzip makeWrapper ];

  unpackPhase = ''
    mkdir src
    cd src
    unzip $src || true
    # offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $src); echo \$offset" $src)
    # dd if="$src" ibs=$offset skip=1 | gzip -cd | tar xvf - || true
  '';

  libPath = stdenv.lib.makeLibraryPath [
    glibc mesa_noglu xorg.libX11 xorg.libXext xorg.libXcursor libXrandr
    xorg.libXinerama xorg.libXi xorg.libXScrnSaver
    libpulseaudio gcc.cc systemd.lib alsaLib wayland libxkbcommon ];

  buildPhase = ''
    patchelf \
      --set-rpath "${stdenv.lib.makeLibraryPath [ xorg.libX11 ]}" \
      --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      ./data/noarch/game/tld.x86_64
    # patchelf \
    #   --set-rpath "${stdenv.lib.makeLibraryPath [ xorg.libX11 ]}" \
    #   --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
    #   ./data/noarch/game/StardewValley.bin.x86_64
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out/
    makeWrapper "$out/data/noarch/start.sh" "$out/bin/the-long-dark" \
       --prefix LD_LIBRARY_PATH : "${libPath}"
    # makeWrapper \
    #   "$out/data/noarch/start.sh" \
    #   "$out/bin/stardew-valley" \
    #   --prefix LD_LIBRARY_PATH : "${libPath}"
  '';
}
