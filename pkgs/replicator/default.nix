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
    rev = "a1f60adf0f593473a7bc7ea751129edd8894811a";
    sha256 = "98c7a0e81fd1f74cdd80d0464b14624a1bcb4d7d38aa590beeb2522bd1a7e992";
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
