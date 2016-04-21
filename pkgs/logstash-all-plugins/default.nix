{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "logstash-all-plugins-2.3.1";

  src = fetchurl {
    url = "https://download.elasticsearch.org/logstash/logstash/${name}.tar.gz";
    sha256 = "1zi2d0q7nhcfrp1xq6sq65x4d0kk8rh3ip5wd8a8lkyibcyxxppc";
  };

  dontBuild         = true;
  dontPatchELF      = true;
  dontStrip         = true;
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out
    cp -r {Gemfile*,vendor,lib,bin} $out
  '';
}
