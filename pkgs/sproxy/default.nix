{ mkDerivation, aeson, attoparsec, base, bytestring
, case-insensitive, certificate, containers, crypto-random
, data-default, fetchgit, hslogger, http-conduit, http-kit
, http-types, interpolatedstring-perl6, mtl, network
, optparse-applicative, safe, SHA, split, stdenv, string-conversions
, time, tls, unix, unordered-containers, utf8-string, x509, yaml
}:
mkDerivation {
  pname = "sproxy";
  version = "0.8.0";
  src = fetchgit {
    url = "https://github.com/zalora/sproxy.git";
    sha256 = "fbf706eb34225f99f04eadc87fd04128292f77b0de1b59ab3c976d67e7dd0b3b";
    rev = "c3e999cf381483f6ff64612ff1c2eaff5ea375f2";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring case-insensitive certificate
    containers crypto-random data-default hslogger http-conduit
    http-kit http-types interpolatedstring-perl6 mtl network safe SHA
    split string-conversions time tls unix unordered-containers
    utf8-string x509 yaml
  ];
  executableHaskellDepends = [ base optparse-applicative ];
  license = stdenv.lib.licenses.mit;
}
