{ mkDerivation, amazonka-core, amazonka-test, base, bytestring
, lens, stdenv, tasty, tasty-hunit, text, time
, unordered-containers
}:
mkDerivation {
  pname = "amazonka-route53";
  version = "1.3.6";
  sha256 = "1py4zn5ag7jm8pm0ym09lll41kbiwp4q678yq8yschsbkba24p2z";
  libraryHaskellDepends = [ amazonka-core base ];
  testHaskellDepends = [
    amazonka-core amazonka-test base bytestring lens tasty tasty-hunit
    text time unordered-containers
  ];
  homepage = "https://github.com/brendanhay/amazonka";
  description = "Amazon Route 53 SDK";
  license = "unknown";
}
