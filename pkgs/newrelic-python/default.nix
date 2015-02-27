{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;
with pkgs.stdenv;

pythonPackages.buildPythonPackage rec {
  name = "newrelic-python-2.18.1.15";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/n/newrelic/newrelic-2.18.1.15.tar.gz";
    md5 = "f0421d3752d6b2f208ebf01c3265b259";
  };

  meta = with stdenv.lib; {
    description = "Python agent for New Relic";
    homepage = http://newrelic.com/docs/python/new-relic-for-python;
  };
}
