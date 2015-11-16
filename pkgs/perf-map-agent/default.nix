{ stdenv, fetchgit, cmake, openjdk }:

stdenv.mkDerivation {
  name = "perf-map-agent";
  src = fetchgit {
    url = https://github.com/jrudolph/perf-map-agent;
    rev = "3acf8f487c444266eaaa8037b5a6de8573347313";
    sha256 = "4526fd92dc82dfec21fff94b67345464204778068c788c4b0a943bf986a27bb4";
  };
  buildInputs = [cmake openjdk];
  cmakeFlags = [
    "-DJAVA_HOME=${openjdk}/lib/openjdk/jre/"
    "-DJAVA_INCLUDE_PATH=${openjdk}/lib/openjdk/lib"
    "-DJAVA_INCLUDE_PATH2=${openjdk}/include/linux/"
  ];
  installPhase = ''
    mkdir $out
    cp -r out/attach-main.jar out/libperfmap.so $out
  '';
}
