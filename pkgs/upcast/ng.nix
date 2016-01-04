{ mkDerivation, aeson, aeson-pretty, amazonka, amazonka-core
, amazonka-ec2, amazonka-elb, amazonka-route53, array, async
, attoparsec, base, base64-bytestring, bifunctors, bytestring
, conduit, conduit-extra, containers, directory, exceptions
, fetchgit, filepath, hashable, iproute, lens, lens-action
, lens-aeson, lifted-base, mtl, natural-sort, optparse-applicative
, pretty-show, process, random, resourcet, scientific, semigroups
, stdenv, tagged, text, time, unix, unordered-containers, vector
, vk-posix-pty, witherable, xml-conduit
}:
mkDerivation {
  pname = "upcast";
  version = "0.1.1.0";
  src = fetchgit {
    url = git://github.com/zalora/upcast.git;
    rev = "426a3b74ccd5534a330b9993b11b70d91e0da30c";
    sha256 = "7a984690faafaff1257fc4f65e963f39f4cc8c4307a00382ddcaa3050fdb6bdc";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-ec2 amazonka-elb
    amazonka-route53 array async attoparsec base base64-bytestring
    bifunctors bytestring conduit conduit-extra containers directory
    exceptions filepath hashable iproute lens lens-action lens-aeson
    lifted-base mtl natural-sort optparse-applicative pretty-show
    process random resourcet scientific semigroups tagged text time
    unix unordered-containers vector vk-posix-pty witherable
    xml-conduit
  ];
  executableHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-ec2 amazonka-elb
    amazonka-route53 array async attoparsec base base64-bytestring
    bifunctors bytestring conduit conduit-extra containers directory
    exceptions filepath hashable iproute lens lens-action lens-aeson
    lifted-base mtl natural-sort optparse-applicative pretty-show
    process random resourcet scientific semigroups tagged text time
    unix unordered-containers vector vk-posix-pty witherable
    xml-conduit
  ];
  homepage = "https://github.com/zalora/upcast#readme";
  description = "Nix-based Linux deployment platform tools";
  license = stdenv.lib.licenses.mit;
}
