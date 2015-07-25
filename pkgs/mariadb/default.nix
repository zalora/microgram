{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl }:

stdenv.mkDerivation rec {
  name = "mariadb-${version}";

  # Do not bump until https://mariadb.atlassian.net/browse/MDEV-8540 is fixed
  version = "10.0.15";

  src = fetchurl {
    url = "https://github.com/MariaDB/server/archive/${name}.tar.gz";
    sha256 = "1maa0mwqxljh9nd0kjbcr9hy9v9k2x25b15xb5d5p41wadrxk6jy";
  };

  buildInputs = [ cmake bison ncurses openssl perl readline zlib ]
     ++ stdenv.lib.optional stdenv.isDarwin perl;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DWITH_SSL=yes"
    "-DWITH_READLINE=yes"
    "-DWITH_EMBEDDED_SERVER=no"
    "-DWITH_ZLIB=yes"
    "-DHAVE_IPV6=yes"
    "-DWITHOUT_TOKUDB=1"
    "-DINSTALL_SCRIPTDIR=bin"
  ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake
  '';
  postInstall = ''
    sed -i -e "s|-lssl|-L${openssl}/lib -lssl|g" $out/bin/mysql_config
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    # https://github.com/NixOS/nixpkgs/issues/7117
    rm -r $out/mysql-test $out/sql-bench $out/data # Don't need testing data
    rm $out/share/man/man1/mysql-test-run.pl.1
    rm $out/bin/rcmysql # Not needed with nixos units
    rm $out/bin/mysqlbug # Encodes a path to gcc and not really useful
    find $out/bin -name \*test\* -exec rm {} \;
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
