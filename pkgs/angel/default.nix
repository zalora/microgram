{ cabal, configurator, hspec, mtl, stm, text, time
, unorderedContainers, optparseApplicative
}:

cabal.mkDerivation (self: {
  pname = "angel";
  version = "0.5.2";
  sha256 = "0h2nyxv56cshkxlbq5j54220w7x2y0m1aaqzqz6dhipff29pmr39";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    configurator mtl stm text time unorderedContainers
  ];
  testDepends = [
    configurator hspec mtl stm text time unorderedContainers optparseApplicative
  ];
  patches = [ ./static.patch ];
  meta = {
    homepage = "http://github.com/MichaelXavier/Angel";
    description = "Process management and supervision daemon";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
