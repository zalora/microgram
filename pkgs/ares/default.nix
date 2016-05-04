{ fetchgit, mkDerivation, aeson, attoparsec, base, bytestring, cond, containers
, directory, extra, filelock, filepath, network, process
, servant-server, stdenv, temporary, text, transformers, Unique
, unix, wai, wai-extra, warp
}:
mkDerivation {
  pname = "ares";
  version = "3";
  src = fetchgit {
    url = https://github.com/zalora/ares;
    rev = "cdc81cc55f7b27543bec5eb6cd79228abcb3b8c8";
    sha256 = "0xwxrsw758vbnz79q1c6ijnpz65ksx93i970sp45ry4h3ycyvlvm";
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
