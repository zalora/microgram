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
    rev = "6d5fd21b184be9ce8d5d023d9978c71bb57f7023";
    sha256 = "7ebf28c93050cb01c764673bd48ed1f9effbdc97e82b28a4a35f437126c22b7b";
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
