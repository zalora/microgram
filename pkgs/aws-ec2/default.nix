{ cabal, aeson, aws, base16Bytestring, base64Bytestring
, blazeBuilder, byteable, conduitExtra, cryptohash, httpConduit
, httpTypes, mtl, optparseApplicative, resourcet, scientific, text
, time, unorderedContainers, vector, xmlConduit, yaml
, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "aws-ec2";
  src = fetchgit {
    url = "git://github.com/zalora/aws-ec2";
    rev = "8f47578b50860357fa07594e3a68f9d772183844";
    sha256 = "37ecafd0356819a8e637b7c90054d01fa93b16938ceb362cf6148b526842b1ae";
  };
  version = "0.3.2";
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  buildDepends = [
    aeson aws base16Bytestring base64Bytestring blazeBuilder byteable
    conduitExtra cryptohash httpConduit httpTypes mtl
    optparseApplicative resourcet scientific text time
    unorderedContainers vector xmlConduit yaml
  ];
  meta = {
    homepage = "https://github.com/zalora/aws-ec2";
    description = "AWS EC2/VPC, ELB and CloudWatch client library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
