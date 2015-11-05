{ fetchgit, mkDerivation, aeson, attoparsec, base, bytestring, containers
, directory, extra, filelock, filepath, network, process
, servant-server, stdenv, temporary, text, transformers, Unique
, unix, wai, wai-extra, warp, linux-mount
}:
mkDerivation {
  pname = "ares";
  version = "0";
  patches = [ ./ug.patch ];
  src = fetchgit {
    url = https://github.com/zalora/ares;
    rev = "c29c837efa0521445aeaadbd5c4bb1d932d034af";
    sha256 = "28bd5b3513ef571314b775319c9d69f59809ebfa74fed3447b79df1a70d0aac7";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson attoparsec base bytestring containers directory extra
    filelock filepath network process servant-server temporary text
    transformers Unique unix wai wai-extra warp linux-mount
  ];
  license = stdenv.lib.licenses.bsd3;
}
