{ mkDerivation, aeson, aeson-pretty, amazonka, amazonka-core
, amazonka-ec2, amazonka-elb, amazonka-route53, async, attoparsec
, base, base64-bytestring, bytestring, conduit, conduit-extra
, containers, directory, exceptions, fetchgit, filepath, lens
, lifted-base, mtl, natural-sort, optparse-applicative, pretty-show
, process, random, resourcet, scientific, semigroups, stdenv
, tagged, text, time, unix, unordered-containers, vector
, vk-posix-pty, xml-conduit
}:
mkDerivation {
  pname = "upcast";
  version = "0.1.1.0";
  src = fetchgit {
    url = "https://github.com/zalora/upcast.git";
    sha256 = "dbb721b2bbbe549cd4608d15c4abc8b6e25c7f5dd9c25fe9b7b62a381e17f8a0";
    rev = "ed869de9551cce1eff1d35941d145e4075d9f1fe";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-ec2 amazonka-elb
    amazonka-route53 async attoparsec base base64-bytestring bytestring
    conduit conduit-extra containers directory exceptions filepath lens
    lifted-base mtl natural-sort optparse-applicative pretty-show
    process random resourcet scientific semigroups tagged text time
    unix unordered-containers vector vk-posix-pty xml-conduit
  ];
  executableHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-ec2 amazonka-elb
    amazonka-route53 async attoparsec base base64-bytestring bytestring
    conduit conduit-extra containers directory exceptions filepath lens
    lifted-base mtl natural-sort optparse-applicative pretty-show
    process random resourcet scientific semigroups tagged text time
    unix unordered-containers vector vk-posix-pty xml-conduit
  ];
  homepage = "https://github.com/zalora/upcast#readme";
  description = "Nix-based Linux deployment platform tools";
  license = stdenv.lib.licenses.mit;
}
