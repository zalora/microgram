{ fetchgit, mkDerivation, aeson, attoparsec, base, bytestring, cond, containers
, directory, extra, filelock, filepath, network, process
, servant-server, stdenv, temporary, text, transformers, Unique
, unix, wai, wai-extra, warp
}:
mkDerivation {
  pname = "ares";
  version = "4";
  src = fetchgit {
    url = https://github.com/zalora/ares;
    rev = "8521dc9ec47c7ac01be69280998fa4b45170bba8";
    sha256 = "1mjvskhp63ksrd2rs60vck8qvj2mvcdqw999yc5fg58gl152i1gh";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson attoparsec base bytestring cond containers directory extra
    filelock filepath network process servant-server temporary text
    transformers Unique unix wai wai-extra warp
  ];
  license = stdenv.lib.licenses.bsd3;
}
