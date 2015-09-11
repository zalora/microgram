{ mkDerivation, base, configurator, containers, fetchzip, hspec
, mtl, old-locale, process, stdenv, stm, text, time, unix
, unordered-containers
}:
mkDerivation {
  pname = "angel";
  # do not bump until https://github.com/MichaelXavier/Angel/issues/40 is fixed
  version = "0.5.1";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/angel-0.5.1/angel-0.5.1.tar.gz";
    sha256 = "1qa7kfaia429la645naixfns5i9s775p9vzvlpk0xpz8zs8zfxcw";
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
