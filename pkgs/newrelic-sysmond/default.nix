{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;

stdenv.mkDerivation rec {
  name = "newrelic-sysmond-${version}";
  version = "2.0.2.111";

  buildPhase = ":";
  installPhase = ''
    ensureDir $out/bin
    cp daemon/nrsysmond.x64 $out/bin/
    ${patchelf}/bin/patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/bin/nrsysmond.x64
    eval fixupPhase
  '';

  src = fetchurl {
    url = "https://download.newrelic.com/server_monitor/archive/${version}/${name}-linux.tar.gz";
    sha256 = "036bayrl53fnnwnyhz0h9dg0bsrm9ahbw531hiwy2ycm6vj6ic4g";
  };
}
