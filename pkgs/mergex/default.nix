{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "mergex";
  src = fetchgit {
    url = "https://github.com/NicoJuicy/mergex.git";
    rev = "d038ceb60d00bb788afe0d51d0b4d4e412f5a333";
    sha256 = "0cqq4a1pclkbys84x5v1bxvlm4a6d1h9536jan0cg5p8fdajzaga";
  };
  buildPhase = ''
    make all
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv -v mergex $out/bin/
  '';
}
