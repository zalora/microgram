{ fetchgit, mkDerivation, aeson, attoparsec, base, bytestring, containers
, directory, extra, filelock, filepath, network, process
, servant-server, stdenv, temporary, text, transformers, Unique
, unix, wai, wai-extra, warp
}:
mkDerivation {
  pname = "ares";
  version = "1";
  patches = [ ./ug.patch ];
  src = fetchgit {
    url = https://github.com/zalora/ares;
    rev = "ff27e1ba950f40d5a08a6976abb4a2e532a57da9";
    sha256 = "118c0f4dfc6955039e07d7d1c27f876fd0ae10ab2301c0a1c2ddfc380d77130b";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson attoparsec base bytestring containers directory extra
    filelock filepath network process servant-server temporary text
    transformers Unique unix wai wai-extra warp
  ];
  license = stdenv.lib.licenses.bsd3;
}
