{ cabal, aeson, aesonPretty, async, attoparsec, aws, awsEc2
, base64Bytestring, conduit, conduitExtra, filepath, free
, haskellSrcMeta, httpConduit, httpTypes, liftedBase, mtl
, optparseApplicative, prettyShow, random, resourcet, scientific
, text, time, unorderedContainers, vector, vkAwsRoute53, vkPosixPty
, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "upcast";
  src = fetchgit {
    url = "git://github.com/zalora/upcast.git";
    rev = "88d565f36453198c2e999ae07fdfc5dd98c382e5";
    sha256 = "06313b5ebcece5100310236effed2f83694bec5c88f7b951dd697c3acb2f6fc2";
  };
  version = "pre";
  noHaddock = true;
  isLibrary = false;
  isExecutable = true;
  jailbreak = true;
  buildDepends = [
    aeson aesonPretty async attoparsec aws base64Bytestring
    conduit conduitExtra filepath free haskellSrcMeta httpConduit
    httpTypes liftedBase mtl optparseApplicative prettyShow random
    resourcet scientific text time unorderedContainers vector

    awsEc2 vkAwsRoute53 vkPosixPty
  ];
  meta = {
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
