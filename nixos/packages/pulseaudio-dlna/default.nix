{ stdenv, fetchFromGitHub, python27Packages }:

python27Packages.buildPythonApplication rec {
  name = "pulseaudio-dlna-${version}";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "masmu";
    repo = "pulseaudio-dlna";
    rev = version;
    sha256 = "1y8mhd537x0nfippy8mn9a0iq9xdisixign0372ldp9pwy8w7fd4";
  };

  propagatedBuildInputs = with python27Packages; [
    docopt requests2 setproctitle protobuf notify2 psutil futures chardet
    netaddr netifaces lxml zeroconf pygobject2
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/masmu/pulseaudio-dlna;
    description = "A DLNA server which brings DLNA / UPNP support to PulseAudio";
    license = licenses.gpl3;
    maintainers = with maintainers; [ orbekk ];
    platforms = platforms.linux;
  };
}
