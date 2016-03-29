{ mkDerivation, aeson, aeson-pretty, amazonka, amazonka-cloudwatch
, amazonka-core, amazonka-ec2, amazonka-elb, amazonka-route53, array, async
, attoparsec, base, base64-bytestring, bifunctors, bytestring
, conduit, conduit-extra, containers, directory, exceptions
, fetchgit, filepath, hashable, iproute, lens, lens-action
, lens-aeson, lifted-base, mtl, natural-sort, optparse-applicative
, pretty-show, process, random, resourcet, scientific, semigroups
, stdenv, tagged, text, time, unix, unordered-containers, vector
, vk-posix-pty, witherable
}:
mkDerivation {
  pname = "upcast";
  version = "0.1.1.0";
  src = fetchgit {
    url = git://github.com/zalora/upcast.git;
    rev = "eac3b8c89e69d55d566f59f30e0226926381766d";
    sha256 = "ded7efa4a43915e656ca8117b1d01257f03eba9c1b8197d5c627efe1b5159667";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-cloudwatch amazonka-core amazonka-ec2 amazonka-elb
    amazonka-route53 array async attoparsec base base64-bytestring
    bifunctors bytestring conduit conduit-extra containers directory
    exceptions filepath hashable iproute lens lens-action lens-aeson
    lifted-base mtl natural-sort optparse-applicative pretty-show
    process random resourcet scientific semigroups tagged text time
    unix unordered-containers vector vk-posix-pty witherable
  ];
  executableHaskellDepends = [
    optparse-applicative
  ];
  homepage = "https://github.com/zalora/upcast#readme";
  description = "Nix-based Linux deployment platform tools";
  license = stdenv.lib.licenses.mit;
}
