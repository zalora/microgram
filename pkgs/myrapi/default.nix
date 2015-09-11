{ mkDerivation, aeson, base, base64-bytestring, byteable
, bytestring, cryptohash, either, fetchgit, http-types, old-locale
, optparse-applicative, servant, servant-client, stdenv, text, time
, transformers
}:
mkDerivation {
  pname = "myrapi";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/zalora/myrapi.git";
    sha256 = "7c4d2e2b212c84b0b4fb9be277ea4c8b166781bbdcbbd64efb6ca923add2ae11";
    rev = "f26754131d4dd4adb8657d2ad2e9803ac8601704";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base64-bytestring byteable bytestring cryptohash either
    http-types old-locale servant servant-client text time transformers
  ];
  executableHaskellDepends = [
    aeson base bytestring optparse-applicative servant servant-client
    text
  ];
  license = stdenv.lib.licenses.mit;
}
