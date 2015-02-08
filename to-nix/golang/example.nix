{ stdenv, go, src }:

let
  name = "my-app";
  namespace = "github.com/zalora/myApp";
in
stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p "Godeps/_workspace/src/${namespace}"
    ln -s $src Godeps/_workspace/src/${namespace}"
    GOPATH=$PWD/Godeps/_workspace go build -o ${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
    # probably need to copy more things here
  '';
}
