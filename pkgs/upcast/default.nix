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
    rev = "2af0b9e107fd3f2000bcd16bd8e20e1e15c9a1e4";
    sha256 = "25facc97abfddb3a91404d7877db31edacb8a573af60ae5d9d6824519e711e79";
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
