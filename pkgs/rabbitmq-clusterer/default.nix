{ pkgs, stdenv }:
stdenv.mkDerivation rec {
  name = "rabbitmq-clusterer-${version}";
  version = "3.6.x-667f92b0";
  src = pkgs.fetchurl {
    url = "https://www.rabbitmq.com/community-plugins/v3.6.x/rabbitmq_clusterer-${version}.ez";
    sha256 = "1ziknm1alvlzns5adpg9c7xzq3m65jnc1qnfc2lcr01hscll0nv1";
  };
  phases = [ "unpackPhase" "buildPhase" ];
  unpackCmd = "${pkgs.unzip}/bin/unzip -q $curSrc";
  buildPhase = "cp -r . $out";
}
