{ bash, fetchgit, go, stdenv }:
let
  version = "1.2.1";
  go-libGeoIP = fetchgit {
    url = https://github.com/nranchev/go-libGeoIP;
    rev = "c78e8bd2dd3599feb21fd30886043979e82fe948";
    sha256 = "035khy2b84gc96b08c5rq3a5p6d8860vysbdj8ww9p0p2nracy5d";
  };
in
stdenv.mkDerivation {
  name = "filebeat-${version}";
  src = fetchgit {
    url = https://github.com/elastic/beats;
    rev = "refs/tags/v${version}";
    sha256 = "0yy2pg4sncn9p0zlc5wbri3lx0q4f03vg02lv2bvddyl5yy7phy1";
  };
  buildInputs = [ go ];
  patchPhase = ''
    find -type f -exec sed -i 's:/bin/bash:${bash}&:g' {} \;
  '';
  buildPhase = ''
    export GOPATH=$GOPATH:$PWD:$PWD/vendor
    mkdir -p src/github.com/elastic
    ln -sf $PWD src/github.com/elastic/beats
    make -C filebeat
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp filebeat/filebeat $out/bin

    # trick nix into not considering go as a runtime dependency
    go_path=${go}
    go_path=''${go_path#/nix/store/}
    go_path=''${go_path%%-go-*}
    sed -i "s#$go_path#................................#g" $out/bin/filebeat
  '';
}
