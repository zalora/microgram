{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, yacc }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.6.4";

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng/releases/download/syslog-ng-${version}/syslog-ng-${version}.tar.gz";
    sha256 = "1rzl0s8kv1bafwiv4h9scgfrw172x1d2pqjjz7qidmy73brivqbv";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl riemann_c_client protobufc yacc ];

  configureFlags = [
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
  };
}
