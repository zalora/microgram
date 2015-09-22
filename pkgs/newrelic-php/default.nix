{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name = "newrelic-php5-${version}";

  version = "4.9.0.54";

  src = fetchurl {
    url = "https://download.newrelic.com/php_agent/archive/${version}/${name}-linux.tar.gz";
    sha256 = "160pjaqhjj7gii27zaay3khaalx7vaslxpaisjjg6ad16nnl8ia5";
  };

  buildPhase = ":";
  installPhase = ''
    ensureDir $out/bin
    cp daemon/newrelic-daemon.x64 $out/bin/
    ${patchelf}/bin/patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/newrelic-daemon.x64
    cp scripts/newrelic-iutil.x64 $out/bin/
    ${patchelf}/bin/patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/newrelic-iutil.x64
    ensureDir $out/extensions
    cp agent/x64/newrelic-20100525.so $out/extensions/newrelic.so
    eval fixupPhase
  '';

  meta = with stdenv.lib; {
    description = "PHP agent for New Relic";
    homepage = http://newrelic.com/docs/php/new-relic-for-php;
  };
}
