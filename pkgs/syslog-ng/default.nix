{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, yacc, openssl }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.7.1";

  dontStrip = true;
  stripAllFlags = "";
  stripDebugFlags = "";
  stripDebugList = [];

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng/releases/download/syslog-ng-${version}/syslog-ng-${version}.tar.gz";
    sha256 = "0802qanvy68zqgs4iiji9p843bvkyaxnw7jbh76pgcvrj0dq86ac";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl riemann_c_client protobufc yacc openssl ];

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
