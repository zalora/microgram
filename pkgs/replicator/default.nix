{ cabal, ConfigFile, filepath, Glob, hflags, lensFamilyCore, MissingH
, monadParallel, mtl, pipes, pipesBytestring, pipesGroup, pipesSafe
, pipesShell, pipesZlib, rawStringsQq, regexApplicative, time
, transformers
, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "replicator";
  version = "git";
  src = fetchgit {
    url = "git://github.com/zalora/replicator.git";
    rev = "07f09121e6e91304db831910f0b8ba477f477e04";
    sha256 = "5c0446ae528a576639b194c4eb3d154504ef95c56c1a9c06e72902c3c2ca0624";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ConfigFile filepath Glob hflags lensFamilyCore MissingH monadParallel
    mtl pipes pipesBytestring pipesGroup pipesSafe pipesShell pipesZlib
    rawStringsQq regexApplicative time transformers
  ];
  meta = {
    description = "Automate creating MySQL multi-source slaves";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
