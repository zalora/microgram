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
    rev = "c8faa2442bc840b7cb2f15d02e113295a6361df8";
    sha256 = "4a8facdb8a564c3a263a1ae1a673624a71560b994f3876fa00b1ace7eaa35cff";
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
