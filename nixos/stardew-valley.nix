{stdenv, glibc, coreutils, patchelf, requireFile, unzip, xorg, makeWrapper, libpulseaudio }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "stardew-valley-${version}";
  version = "2.3.0.4";
  src = requireFile {
    name = "gog_stardew_valley_${version}.sh";
    sha256 = "88e1fae7226c7bfa91cb28c137c24867e12b1a0b6e824e6ffe73e1eefc166aac";
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

  libPath = stdenv.lib.makeLibraryPath [ glibc xorg.libX11 xorg.libXext libpulseaudio ];

  buildPhase = ''
    patchelf \
      --set-rpath "${stdenv.lib.makeLibraryPath [ xorg.libX11 ]}" \
      --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      ./data/noarch/game/mcs.bin.x86_64
    patchelf \
      --set-rpath "${stdenv.lib.makeLibraryPath [ xorg.libX11 ]}" \
      --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      ./data/noarch/game/StardewValley.bin.x86_64
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out/
    makeWrapper \
      "$out/data/noarch/start.sh" \
      "$out/bin/stardew-valley" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';
}
