{ mkDerivation, attoparsec, base, derive, fetchzip, hspec
, hspec-expectations, mtl, mtl-compat, old-locale, process
, QuickCheck, stdenv, text, time, transformers-compat
}:
mkDerivation {
  pname = "cron";
  version = "0.3.0";
  src = fetchzip {
    url = "https://github.com/proger/cron/archive/unicron.zip";
    sha256 = "02lr2ykxhfbzrq10z5cd5cf9019pls22f3wk6xdvg68p1gy43hmm";
  };
  isLibrary = true;
  isExecutable = true;
  configureFlags = [
    "--ghc-option=-threaded"
    "--ghc-option=-rtsopts"
    "--ghc-option=-with-rtsopts=-N"
  ];
  libraryHaskellDepends = [
    attoparsec base mtl mtl-compat old-locale text time
  ];
  executableHaskellDepends = [
    attoparsec base mtl mtl-compat old-locale process text time
  ];
  testHaskellDepends = [
    attoparsec base derive hspec hspec-expectations QuickCheck text
    time transformers-compat
  ];
  doCheck = false;
  homepage = "http://github.com/michaelxavier/cron";
  description = "Cron datatypes and Attoparsec parser";
  license = stdenv.lib.licenses.mit;
}
