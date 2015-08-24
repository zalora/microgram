{ mkDerivation, amazonka-core, base, bytestring
, fetchzip, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-route53";
  version = "1.1.0";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/amazonka-route53-1.1.0/amazonka-route53-1.1.0.tar.gz";
    sha256 = "010ysab2nw44km76kdxw2bc95vfpcy9vm4ghxa1lal88flx9caib";
  };
  libraryHaskellDepends = [ amazonka-core base ];
  doHaddock = false;
  doCheck = false;
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Route 53 SDK";
  license = "unknown";
}
