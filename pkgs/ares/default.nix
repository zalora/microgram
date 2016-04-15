{ fetchgit, mkDerivation, aeson, attoparsec, base, bytestring, containers
, directory, extra, filelock, filepath, network, process
, servant-server, stdenv, temporary, text, transformers, Unique
, unix, wai, wai-extra, warp
}:
mkDerivation {
  pname = "ares";
  version = "2";
  patches = [ ./ug.patch ];
  src = fetchgit {
    url = https://github.com/zalora/ares;
    rev = "880a6ca5ddf23a3dba366d89ec253ebe3f72da07";
    sha256 = "1ms4w8ac7i1y0iv8z57x9rmfj5djns9d6yq3bysjz4rjsmanbh33";
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
