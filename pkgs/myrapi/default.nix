{ cabal, aeson, base64Bytestring, byteable, cryptohash, either
, httpTypes, optparseApplicative, servant, servantClient, text
, time, transformers, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "myrapi";
  version = "0.1.0.0";
  src = fetchgit {
    url = "git://github.com/zalora/myrapi.git";
    rev = "f26754131d4dd4adb8657d2ad2e9803ac8601704";
    sha256 = "7c4d2e2b212c84b0b4fb9be277ea4c8b166781bbdcbbd64efb6ca923add2ae11";
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
