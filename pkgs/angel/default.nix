{ cabal, configurator, hspec, mtl, stm, text, time
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "angel";
  version = "0.5.1";
  sha256 = "1ag5bpwfmshcwhycp12ywqvhf4d1fdfs9haawzhawnjpcm5h2hha";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    configurator mtl stm text time unorderedContainers
  ];
  testDepends = [
    configurator hspec mtl stm text time unorderedContainers
  ];
  patches = [ ./static.patch ./less-logs.patch ];
  meta = {
    homepage = "http://github.com/MichaelXavier/Angel";
    description = "Process management and supervision daemon";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
