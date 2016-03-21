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
    rev = "426a3b74ccd5534a330b9993b11b70d91e0da30c";
    sha256 = "1p3bvc7hb8yavn1078078f6crx1r7yb5xxn4gwjz3bxgza84d63s";
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
