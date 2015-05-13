{ stdenv, fetchurl, scons, boost, openssl, buildEnv, check }:

let
  libs = buildEnv {
    name = "galera-lib-inputs-united";
    paths = [ openssl boost.lib check ];
  };
in

stdenv.mkDerivation rec {
  name = "galera-wsrep-${version}";
  version = "25.3.10";

  src = fetchurl {
    url = "http://releases.galeracluster.com/source/galera-3-${version}.tar.gz";
    md5 = "0a5083a7fb12b220405064ee5a792035";
  };

  buildInputs = [ scons boost openssl check ];

  patchPhase = ''
    substituteInPlace SConstruct \
      --replace "boost_library_path = '''" "boost_library_path = '${boost.lib}/lib'"
    substituteInPlace SConstruct \
      --replace "boost_library_suffix = '''" "boost_library_suffix = '-mt'"
  '';

  buildPhase = ''
    export CPPFLAGS="-I${boost.dev}/include -I${openssl}/include -I${check}/include"
    export LIBPATH="${libs}/lib"
    scons -j$NIX_BUILD_CORES strict_build_flags=0
  '';

  installPhase = ''
    # copied with modifications from scripts/packages/freebsd.sh
    PBR="$out"
    PBD="$PWD"
    GALERA_LICENSE_DIR="$PBR/share/licenses"

    install -d "$PBR/"{bin,lib/galera,share/doc/galera}
    install -m 555 "$PBD/garb/garbd"                      "$PBR/bin/garbd"
    install -m 444 "$PBD/libgalera_smm.so"                "$PBR/lib/galera/libgalera_smm.so"
    install -m 444 "$PBD/scripts/packages/README"         "$PBR/share/doc/galera/"
    install -m 444 "$PBD/scripts/packages/README-MySQL"   "$PBR/share/doc/galera/"

    install -m 755 -d "$GALERA_LICENSE_DIR"
    install -m 444 "$PBD/LICENSE"                             "$GALERA_LICENSE_DIR/GPLv2"
    install -m 444 "$PBD/scripts/packages/freebsd/LICENSE"    "$GALERA_LICENSE_DIR"
    install -m 444 "$PBD/asio/LICENSE_1_0.txt"                "$GALERA_LICENSE_DIR/LICENSE.asio"
    install -m 444 "$PBD/www.evanjones.ca/LICENSE"            "$GALERA_LICENSE_DIR/LICENSE.crc32c"
    install -m 444 "$PBD/chromium/LICENSE"                    "$GALERA_LICENSE_DIR/LICENSE.chromium"
  '';

  meta = {
    homepage = http://galeracluster.com/;
    description = "Galera 3 wsrep provider library";
  };
}
