{ mkDerivation, amazonka-core, base, bytestring, conduit
, conduit-extra, directory, exceptions, fetchzip, http-client
, http-conduit, ini, lens, mmorph, monad-control, mtl, resourcet
, retry, stdenv, tasty, tasty-hunit, text, time, transformers
, transformers-base, transformers-compat
}:
mkDerivation {
  pname = "amazonka";
  version = "1.1.0";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/amazonka-1.1.0/amazonka-1.1.0.tar.gz";
    sha256 = "1d1khfahsn1lv19y9gkmx61m3bwjin9f44s3iaklhr3ydyaiwwkg";
  };
  libraryHaskellDepends = [
    amazonka-core base bytestring conduit conduit-extra directory
    exceptions http-client http-conduit ini lens mmorph monad-control
    mtl resourcet retry text time transformers transformers-base
    transformers-compat
  ];
  testHaskellDepends = [ base tasty tasty-hunit ];
  doHaddock = false;
  doCheck = false;
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Comprehensive Amazon Web Services SDK";
  license = "unknown";
}
