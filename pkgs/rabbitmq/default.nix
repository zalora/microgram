{ pkgs, stdenv }:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.6.2";

  src = pkgs.fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.xz";
    sha256 = "05h2nshszq91811rpij52lzk2ilycpj2653dhm85w4a42bcsv7mh";
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

  makeFlags = "RMQ_ERLAPP_DIR=$(out)";

  postInstall = ''
    echo 'PATH=${pkgs.erlang}/bin''${PATH:+:$PATH}' >> $out/sbin/rabbitmq-env
  '';
}
