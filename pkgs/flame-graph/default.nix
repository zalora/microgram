{ stdenv, fetchgit, perl }:

stdenv.mkDerivation rec {
  name = "FlameGraph";

  src = fetchgit {
    url = https://github.com/brendangregg/FlameGraph.git;
    rev = "182b24fb635345d48c91ed1de58a08b620312f3d";
    sha256 = "6ca6c9b309b79828f61bc7666a0a88740d1e511b32a97990344a008128075fb6";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.pl $out/bin
  '';
}
