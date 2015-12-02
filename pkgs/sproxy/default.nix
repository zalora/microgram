{ mkDerivation, aeson, attoparsec, base, bytestring, containers
, crypto-random, data-default, fetchgit, hslogger, http-conduit
, http-kit, http-types, interpolatedstring-perl6, network
, optparse-applicative, SHA, split, stdenv, string-conversions
, time, tls, unix, utf8-string, x509, yaml
}:
mkDerivation {
  pname = "sproxy";
  version = "0.8.0";
  src = fetchgit {
    url = "git://github.com/zalora/sproxy";
    sha256 = "b564d417acfea12742a1aa038964b807e4ba4359b3d212e645bb46301da244dd";
    rev = "892b131e0bc34b492ed1f569d03ea1c2ec767ef7";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring containers crypto-random
    data-default hslogger http-conduit http-kit http-types
    interpolatedstring-perl6 network SHA split string-conversions time
    tls unix utf8-string x509 yaml
  ];
  executableHaskellDepends = [ base optparse-applicative ];
  license = stdenv.lib.licenses.mit;
}
