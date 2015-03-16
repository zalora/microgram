{ cabal, aeson, base64Bytestring, byteable, cryptohash, either
, httpTypes, optparseApplicative, servant, servantClient, text
, time, transformers, fetchgit
}:

let
  inherit (import <eris/lib>) git-repo-filter;
in

cabal.mkDerivation (self: {
  pname = "myrapi";
  version = "0.1.0.0";
  src = fetchgit {
    url = "git://github.com/zalora/myrapi.git";
    rev = "ba43f5b160e51e23701d65274425273e15731f4b";
    sha256 = "ba2d8f1993a68544c225b2e3fcda6bcbb7e4698fdb1a2574206710ec6043b5a2";
  };
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring byteable cryptohash either httpTypes
    optparseApplicative servant servantClient text time transformers
  ];
  meta = {
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
