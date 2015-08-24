{ mkDerivation, amazonka-core, base, bytestring
, fetchzip, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-elb";
  version = "1.1.0";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/amazonka-elb-1.1.0/amazonka-elb-1.1.0.tar.gz";
    sha256 = "025fvbw7v95gc4i2pcr7cp1shwwndb52iyy6cqg091ra7h1diswr";
  };
  libraryHaskellDepends = [ amazonka-core base ];
  doHaddock = false;
  doCheck = false;
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Elastic Load Balancing SDK";
  license = "unknown";
}
