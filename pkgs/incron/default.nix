{ stdenv, fetchurl, gnused
}:

stdenv.mkDerivation rec {
  name = "incron-0.5.10";

  src = fetchurl {
    url = "http://inotify.aiken.cz/download/incron/${name}.tar.gz";
    sha256 = "12p7707halp8ji7vsbw1nmimcrgp4ank6r4af97nxhhnbzdvljjx";
  };

  patches = [ ./makefile.patch ];

  preConfigure = ''
    sed -i '1,1i#include <unistd.h>' inotify-cxx.cpp icd-main.cpp
    sed -i '1,1i#include <stdio.h>' icd-main.cpp inotify-cxx.cpp usertable.cpp appargs.cpp
    sed -i 's|strchr(s,|(char*)strchr(s,|' incroncfg.cpp
  '';

  buildInputs = [ gnused ];
}
