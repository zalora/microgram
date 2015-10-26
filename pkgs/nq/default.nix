{ fetchgit, stdenv }:

stdenv.mkDerivation rec {
  name = "nq-0.1";

  src = fetchgit {
    url = https://github.com/chneukirchen/nq;
    rev = "2556453d844f9d5224abd843ea2de3df1e8a0d42";
    sha256 = "cdd7b758a8925e28a3af76e663a55af2d1c8aa14d456ea1bd861227245deb894";
  };

  configurePhase = ''
    sed -i "s:^PREFIX=.*:PREFIX=$out:" Makefile
  '';
}
