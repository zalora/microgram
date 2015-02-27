{ cabal, configurator, hspec, mtl, stm, text, time
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "angel";
  version = "0.5.0";
  sha256 = "15871cxzi6m453fndv49zljansfpaggzriq32c1kdby72ivcf968";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    configurator mtl stm text time unorderedContainers
  ];
  testDepends = [
    configurator hspec mtl stm text time unorderedContainers
  ];
  patches = [ ./static.patch ];
  meta = {
    homepage = "http://github.com/MichaelXavier/Angel";
    description = "Process management and supervision daemon";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
