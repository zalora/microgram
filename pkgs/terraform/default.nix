{ fetchurl, stdenv, unzip }:
let
  version = "0.6.9";
in stdenv.mkDerivation rec {
  name = "terraform-${version}";
  src = fetchurl {
    url = "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip";
    sha256 = "1rpsmdlsz2mvaj57gyyjh4c6ygw7pd0lpxgqxx3rzgk5w5nygly7";
  };
  buildInputs = [ unzip ];
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    mv $sourceRoot/terraform* $out/bin/
    chmod +x $out/bin/*
  '';
}
