{ mkDerivation, amazonka-core, base, bytestring
, fetchzip, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-ec2";
  version = "1.1.0";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/amazonka-ec2-1.1.0/amazonka-ec2-1.1.0.tar.gz";
    sha256 = "1xfdmr7vnaqmqhsay6572gx1f86c8vny0z9pv9gawfsk65vffdvz";
  };
  libraryHaskellDepends = [ amazonka-core base ];
  doHaddock = false;
  doCheck = false;
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Elastic Compute Cloud SDK";
  license = "unknown";
}
