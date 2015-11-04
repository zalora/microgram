{ mkDerivation, aeson, base, base64-bytestring, byteable
, bytestring, cryptohash, either, fetchgit, http-types, old-locale
, optparse-applicative, servant, servant-client, stdenv, text, time
, time-locale-compat, transformers
}:
mkDerivation {
  pname = "myrapi";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/zalora/myrapi.git";
    sha256 = "cab997dbfdc059fbb93571cf64f51ba45015f2f6c92040b1c961f20fe35b6096";
    rev = "ed359ed4a522447a3549135160b4cda803254031";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base64-bytestring byteable bytestring cryptohash either
    http-types old-locale servant servant-client text time
    time-locale-compat transformers
  ];
  executableHaskellDepends = [
    aeson base bytestring optparse-applicative servant servant-client
    text
  ];
  license = stdenv.lib.licenses.mit;
}
