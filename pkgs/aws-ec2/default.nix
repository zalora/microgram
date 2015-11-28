{ mkDerivation, aeson, aws, base, base16-bytestring
, base64-bytestring, blaze-builder, byteable, bytestring
, conduit-extra, containers, cryptohash, fetchzip, http-conduit
, http-types, mtl, optparse-applicative, resourcet, scientific
, stdenv, template-haskell, text, time, unordered-containers
, vector, xml-conduit, yaml
}:
mkDerivation {
  pname = "aws-ec2";
  version = "0.3.3";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/aws-ec2-0.3.3/aws-ec2-0.3.3.tar.gz";
    sha256 = "15bdx39yphyb2w1v4rjsd8wh1s5nz3hdpqdfl4jws6lvcsrd40fc";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aws base base16-bytestring base64-bytestring blaze-builder
    byteable bytestring conduit-extra containers cryptohash
    http-conduit http-types mtl resourcet scientific template-haskell
    text time unordered-containers vector xml-conduit
  ];
  executableHaskellDepends = [
    aeson aws base bytestring containers optparse-applicative text
    unordered-containers vector yaml
  ];
  homepage = "https://github.com/zalora/aws-ec2";
  description = "AWS EC2/VPC, ELB and CloudWatch client library for Haskell";
  license = stdenv.lib.licenses.bsd3;
}
