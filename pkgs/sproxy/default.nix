{ mkDerivation, aeson, attoparsec, base, bytestring, connection
, containers, crypto-random, data-default, fetchgit, hspec
, http-conduit, http-kit, http-types, interpolatedstring-perl6
, logging-facade, logsink, network, optparse-applicative
, postgresql-simple, resource-pool, SHA, split, stdenv
, string-conversions, time, tls, unix, utf8-string, wai, warp, x509
, yaml
}:
mkDerivation {
  pname = "sproxy";
  version = "0.9.0";
  src = fetchgit {
    url = "https://github.com/zalora/sproxy.git";
    sha256 = "42498ae6a6ebdb78b451c4c3eb4532e2bac69f34ecc3dc3c47d8687a8ce38ab3";
    rev = "d039fcb31a86290b8b76e0a82e08628781646e69";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring containers crypto-random
    data-default http-conduit http-kit http-types
    interpolatedstring-perl6 logging-facade logsink network
    postgresql-simple resource-pool SHA split string-conversions time
    tls unix utf8-string x509 yaml
  ];
  executableHaskellDepends = [ base optparse-applicative ];
  testHaskellDepends = [
    aeson attoparsec base bytestring connection containers
    crypto-random data-default hspec http-conduit http-kit http-types
    interpolatedstring-perl6 logging-facade logsink network
    postgresql-simple resource-pool SHA split string-conversions time
    tls unix utf8-string wai warp x509 yaml
  ];
  license = stdenv.lib.licenses.mit;
}
