{ mkDerivation, base, bytestring, ConfigFile, containers, directory
, fetchgit, filepath, Glob, hflags, lens-family-core, MissingH
, monad-parallel, mtl, pipes, pipes-bytestring, pipes-group
, pipes-safe, pipes-shell, pipes-zlib, raw-strings-qq
, regex-applicative, stdenv, time, transformers, unix
}:
mkDerivation {
  pname = "replicator";
  version = "0.5.x";
  src = fetchgit {
    url = "https://github.com/zalora/replicator.git";
    rev = "3dbe8614813cd4d1742286b3bce023187871354e";
    sha256 = "1qb8z6cj5rx902r1dni9hq24balvj6mqzcqy4v7ny9h5vv1y88dk";
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
