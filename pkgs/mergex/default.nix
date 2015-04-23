{ stdenv, fetchsvn }:

stdenv.mkDerivation {
  name = "mergex";
  src = fetchsvn {
    url = "http://mergex.googlecode.com/svn/trunk";
    sha256 = "0xn3ci91ch0a108vil1qm2w8l10l0v8iz2ybqic34dhyajy9wwrm";
  };
  buildPhase = ''
    make all
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv -v mergex $out/bin/
  '';
}
