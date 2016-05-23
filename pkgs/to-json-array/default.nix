{ mkDerivation, aeson, base, bytestring, stdenv }:
mkDerivation {
  pname = "to-json-array";
  version = "1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ aeson base bytestring ];
  description = "command-line utility to turn arguments into a JSON array of strings";
  license = stdenv.lib.licenses.unfree;
}
