{ mkDerivation, aeson, attoparsec, base, bytestring, directory
, either, exceptions, fetchzip, hspec, hspec-wai, http-types
, network, network-uri, parsec, QuickCheck, safe, servant, split
, stdenv, string-conversions, system-filepath, temporary, text
, transformers, wai, wai-app-static, wai-extra, warp
}:
mkDerivation {
  pname = "servant-server";
  version = "0.2.4";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/servant-server-0.2.4/servant-server-0.2.4.tar.gz";
    sha256 = "102dgijjg9s4z8vf7436w7mxsv63vvkiqy3vvhpjjxzg66sxbdpl";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring either http-types network-uri safe
    servant split string-conversions system-filepath text transformers
    wai wai-app-static warp
  ];
  executableHaskellDepends = [ aeson base servant text wai warp ];
  testHaskellDepends = [
    aeson base bytestring directory either exceptions hspec hspec-wai
    http-types network parsec QuickCheck servant string-conversions
    temporary text transformers wai wai-extra warp
  ];
  doHaddock = false;
  doCheck = false;
  homepage = "http://haskell-servant.github.io/";
  description = "A family of combinators for defining webservices APIs and serving them";
  license = stdenv.lib.licenses.bsd3;
}
