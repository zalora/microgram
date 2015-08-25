{ mkDerivation, base, fetchzip, hspec, parsec, QuickCheck, stdenv
, string-conversions, template-haskell, text
}:
mkDerivation {
  pname = "servant";
  version = "0.2.2";
  src = fetchzip {
    url = "http://hackage.haskell.org/package/servant-0.2.2/servant-0.2.2.tar.gz";
    sha256 = "0z22rvvim0mm16xqcgdm58h5a4m2545yxjx99vsfnar21213xn44";
  };
  libraryHaskellDepends = [
    base parsec string-conversions template-haskell text
  ];
  testHaskellDepends = [
    base hspec parsec QuickCheck string-conversions text
  ];
  doHaddock = false;
  doCheck = false;
  homepage = "http://haskell-servant.github.io/";
  description = "A family of combinators for defining webservices APIs";
  license = stdenv.lib.licenses.bsd3;
}
