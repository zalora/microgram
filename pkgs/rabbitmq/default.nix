{ pkgs, stdenv }:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.6.1";

  src = pkgs.fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.xz";
    sha256 = "1vhvvryh9bl6hqnfazhh93kbf07zd4nw320j60d1k69zhr7175n6";
  };

  buildInputs = [
    pkgs.docbook_xml_dtd_45
    pkgs.docbook_xsl
    pkgs.erlang
    pkgs.libxml2
    pkgs.libxslt
    pkgs.python
    pkgs.rsync
    pkgs.unzip
    pkgs.xmlto
    pkgs.zip
  ];

  patches = [
    (pkgs.substituteAll {
      inherit (pkgs) coreutils;
      src = ./df.patch;
    })
  ];

  makeFlags = "RMQ_ERLAPP_DIR=$(out)";

  postInstall = ''
    echo 'PATH=${pkgs.erlang}/bin''${PATH:+:$PATH}' >> $out/sbin/rabbitmq-env
  '';
}
