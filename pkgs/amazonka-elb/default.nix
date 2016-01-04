{ mkDerivation, amazonka-core, amazonka-test, base, bytestring
, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-elb";
  version = "1.3.6";
  sha256 = "11s00ss6bh9hqnvmh39cphi0ppnr8x2y95gfyl9kkks56d6dzyc0";
  libraryHaskellDepends = [ amazonka-core base ];
  testHaskellDepends = [
    amazonka-core amazonka-test base bytestring lens tasty tasty-hunit
    text time unordered-containers
  ];
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Elastic Load Balancing SDK";
  license = "unknown";
}
