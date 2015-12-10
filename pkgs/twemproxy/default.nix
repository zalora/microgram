{ fetchurl, autoreconfHook, stdenv }:

stdenv.mkDerivation rec {
  name = "twemproxy-0.4.1";

  buildInputs = [ autoreconfHook ];

  src = fetchurl {
    url = https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz;
    sha256 = "1q7dm1yhalcxzjzaz2i3azkx988smim32j53ayaflywlj47r9hh0";
  };
}
