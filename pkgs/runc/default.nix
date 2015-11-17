{ stdenv, go, libseccomp, fetchgit }:

stdenv.mkDerivation {
  name = "runc";

  src = fetchgit {
    url = https://github.com/opencontainers/runc.git;
    rev = "b28ec60b0e2ae0cefd500fc41e13fb5dca1ba091";
    sha256 = "dfa221984051bf68c9837a0f4db940a880af6dc7cddab02e1fa9c092ac7b0143";
  };

  patches = [
    # brutal hack:
    ./tasks.patch
  ];

  buildInputs = [ go libseccomp ];

  buildPhase = ''
    export GOPATH=$PWD
    mkdir -p src/github.com/opencontainers
    ln -sf $PWD src/github.com/opencontainers/runc
    export CGO_CFLAGS=$CFLAGS
    export CGO_LDFLAGS=$LDFLAGS
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp runc $out/bin

    # trick nix into not considering go as a runtime dependency
    go_path=${go}
    go_path=''${go_path#/nix/store/}
    go_path=''${go_path%%-go-*}
    sed -i "s#$go_path#................................#g" $out/bin/runc
  '';

  dontStrip = true;
}
