{ mkDerivation, aeson, attoparsec, base, bytestring, containers
, crypto-random, data-default, fetchgit, hslogger, http-conduit
, http-kit, http-types, interpolatedstring-perl6, network
, optparse-applicative, SHA, split, stdenv, string-conversions
, time, tls, unix, utf8-string, x509, yaml
}:
mkDerivation {
  pname = "sproxy-lame";
  version = "0.8.0";
  src = fetchgit {
    url = "https://github.com/zalora/sproxy";
    sha256 = "0ka5c69pfz19gggkdkxfin85w2zp8bvd29bkikmggkc79gnwzdqc";
    rev = "c2b70cabe191791ed96e53413ac51b2078723f02";
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
