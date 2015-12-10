{ fetchurl, autoreconfHook, stdenv, openssl }:

stdenv.mkDerivation rec {
  name = "dynomite-0.5.5";

  buildInputs = [ autoreconfHook openssl ];

  src = fetchurl {
    url = https://github.com/Netflix/dynomite/archive/v0.5.5.tar.gz;
    sha256 = "1xpz4rg29a8j0z6fp02swxf405m4d1kfq4jh577197sjw6hwi6v5";
  };
}
