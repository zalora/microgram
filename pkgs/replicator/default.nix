{ mkDerivation, base, bytestring, ConfigFile, containers, directory
, fetchgit, filepath, Glob, hflags, lens-family-core, MissingH
, monad-parallel, mtl, pipes, pipes-bytestring, pipes-group
, pipes-safe, pipes-shell, pipes-zlib, raw-strings-qq
, regex-applicative, stdenv, time, transformers, unix
}:
mkDerivation {
  pname = "replicator";
  version = "0.5.0";
  src = fetchgit {
    url = "https://github.com/zalora/replicator.git";
    sha256 = "5c0446ae528a576639b194c4eb3d154504ef95c56c1a9c06e72902c3c2ca0624";
    rev = "07f09121e6e91304db831910f0b8ba477f477e04";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring ConfigFile containers directory filepath Glob
    hflags lens-family-core MissingH monad-parallel mtl pipes
    pipes-bytestring pipes-group pipes-safe pipes-shell pipes-zlib
    raw-strings-qq regex-applicative time transformers unix
  ];
  description = "Automate creating MySQL multi-source slaves";
  license = stdenv.lib.licenses.mit;
}
