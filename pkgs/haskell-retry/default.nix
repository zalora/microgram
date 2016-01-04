{ mkDerivation, base, data-default-class, exceptions, hspec, HUnit
, QuickCheck, random, stdenv, stm, time, transformers
}:
mkDerivation {
  pname = "retry";
  version = "0.7";
  sha256 = "13rgaj722xc3kf85lclc4qf7jm087cl1wg2vjab0n72rn9c6ns44";
  revision = "1";
  editedCabalFile = "d6fd8a2925a792ae7e787078f52b1c798b41353cc7e4f4ff305e1edff5e7fe2f";
  libraryHaskellDepends = [
    base data-default-class exceptions random transformers
  ];
  testHaskellDepends = [
    base data-default-class exceptions hspec HUnit QuickCheck random
    stm time transformers
  ];
  homepage = "http://github.com/Soostone/retry";
  description = "Retry combinators for monadic actions that may fail";
  license = stdenv.lib.licenses.bsd3;
}
