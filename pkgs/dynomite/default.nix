{ fetchurl, autoreconfHook, stdenv, openssl }:

stdenv.mkDerivation rec {
  name = "dynomite-0.5.6";

  buildInputs = [ autoreconfHook openssl ];

  src = fetchurl {
    url = https://github.com/Netflix/dynomite/archive/v0.5.6.tar.gz;
    sha256 = "1jim17bg414lc4zd007q17hfbpgq8qgqafi06s3p746rzxc0iy6z";
  };
}
