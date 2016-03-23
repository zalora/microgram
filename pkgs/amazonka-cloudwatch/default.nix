{ mkDerivation, amazonka-core, amazonka-test, base, bytestring
, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-cloudwatch";
  version = "1.3.6";
  sha256 = "0xnxmm5xz1icy2992by25w41l8qv2hkmf0c9f362zxxp0xljhs55";
  libraryHaskellDepends = [ amazonka-core base ];
  testHaskellDepends = [
    amazonka-core amazonka-test base bytestring lens tasty tasty-hunit
    text time unordered-containers
  ];
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Route 53 SDK";
  license = "unknown";
}
