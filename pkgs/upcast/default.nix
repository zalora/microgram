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
    sha256 = "e2aaf7ca5e523488648672c24d304de117da76a08f4ff8856c63c5c121be162f";
    rev = "6dee87d134511b35b97f071a1a1384c3f3b9e74b";
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
