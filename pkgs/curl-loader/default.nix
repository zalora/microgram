{ stdenv, fetchurl, openssl, file, zlib }:

stdenv.mkDerivation rec {
  name = "curl-loader-0.56";

  src = fetchurl {
    url = "mirror://sourceforge/curl-loader/${name}.tar.bz2";
    sha256 = "0915jibf2k10afrza72625nsxvqa2rp1vyndv1cy7138mjijn4f2";
  };

  buildInputs = [ openssl file zlib ];

  installPhase = ''
    make DESTDIR=$out install
    mv $out/usr/* $out
  '';
}

