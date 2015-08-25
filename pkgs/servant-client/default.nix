{ mkDerivation, aeson, attoparsec, base, bytestring, deepseq
, either, exceptions, fetchzip, hspec, http-client, http-client-tls
, http-types, network, network-uri, QuickCheck, safe, servant
, servant-server, stdenv, string-conversions, text, transformers
, wai, warp
}:
mkDerivation {
  pname = "servant-client";
  version = "0.2.2";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/servant-client-0.2.2/servant-client-0.2.2.tar.gz";
    sha256 = "04bix96893h5cirv2h8lr0gn0vpr7fmvfk2i8dfkyi3ir45lj5qv";
  };
  libraryHaskellDepends = [
    aeson attoparsec base bytestring either exceptions http-client
    http-client-tls http-types network-uri safe servant
    string-conversions text transformers
  ];
  testHaskellDepends = [
    aeson base bytestring deepseq either hspec http-types network
    QuickCheck servant servant-server wai warp
  ];
  doHaddock = false;
  doCheck = false;
  homepage = "http://haskell-servant.github.io/";
  description = "automatical derivation of querying functions for servant webservices";
  license = stdenv.lib.licenses.bsd3;
}
