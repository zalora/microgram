{ fetchurl, stdenv, unzip }:
let
  version = "0.10.0";
in stdenv.mkDerivation rec {
  name = "packer-${version}";
  src = fetchurl {
    url = "https://releases.hashicorp.com/packer/0.10.0/packer_0.10.0_linux_amd64.zip";
    sha256 = "1ra5kgabwvkhy2078xkffi0gbmiyyjjwvhcz0ls2194g1yy37pga";
  };
  buildInputs = [ unzip ];
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    mv $sourceRoot/packer* $out/bin/
    chmod +x $out/bin/*
  '';
}
