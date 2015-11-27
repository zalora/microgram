{ mkDerivation, base, configurator, containers, fetchgit, hspec
, mtl, old-locale, process, stdenv, stm, text, time, unix
, unordered-containers
}:
mkDerivation {
  pname = "angel";
  # do not bump until https://github.com/MichaelXavier/Angel/issues/40 is fixed
  version = "0.5.1";
  src = fetchgit {
    url = "https://github.com/zalora/Angel.git";
    # branch backports
    rev = "ff7f2dfc08edeede9c9da23ac4e6aa9afd2a56cc";
    sha256 = "0643829fa4378f22220759e17bab8422c50ec8fb15f9ad2474aa04322b0d9a3f";
  };
  patches = [ ./static.patch ./less-logs.patch ];
  isLibrary = false;
  isExecutable = true;
  doCheck = false;
  executableHaskellDepends = [
    base configurator containers mtl old-locale process stm text time
    unix unordered-containers
  ];
  homepage = "http://github.com/MichaelXavier/Angel";
  description = "Process management and supervision daemon";
  license = stdenv.lib.licenses.bsd3;
}
