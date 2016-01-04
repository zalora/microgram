{ mkDerivation, amazonka-core, amazonka-test, base, bytestring
, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-ec2";
  version = "1.3.6";
  sha256 = "15sc9mlbalzaq6w3bsjxdmkhsmjn9qj7wis70vjvk13xy7qnwxfm";
  libraryHaskellDepends = [ amazonka-core base ];
  testHaskellDepends = [
    amazonka-core amazonka-test base bytestring lens tasty tasty-hunit
    text time unordered-containers
  ];
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Elastic Compute Cloud SDK";
  license = "unknown";
}
