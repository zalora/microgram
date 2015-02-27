{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

let
  inherit (pkgs) pythonPackages perlPackages stdenv fetchurl;
in rec {
  erlang = pkgs.callPackage ./erlang {};

  gdb-quiet = stdenv.mkDerivation {
    name = "gdb-quiet";
    unpackPhase = ''
      true
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cat > $out/bin/gdb << EOF
#!/bin/sh
exec ${pkgs.gdb}/bin/gdb -q -ex 'set auto-load safe-path /' "\$@"
EOF
      chmod +x $out/bin/gdb

      runHook postInstall
    '';
  };

  graphviz = pkgs.callPackage ./graphviz {};

  helper = pythonPackages.buildPythonPackage rec {
    name = "helper-2.4.1";

    propagatedBuildInputs = with pythonPackages; [ pyyaml ];
    buildInputs = with pythonPackages; [ mock ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/h/helper/${name}.tar.gz";
      md5 = "e7146c95bbd96a12df8d737a16dca3a7";
    };

    meta = with stdenv.lib; {
      description = "Helper";
      homepage = https://helper.readthedocs.org;
      license = licenses.bsd3;
    };
  };

  newrelic-php = pkgs.callPackage ./newrelic-php {};

  percona-toolkit = import ./percona-toolkit { inherit perlPackages fetchurl; };

  pivotal_agent = pkgs.callPackage ./pivotal_agent {};

  rabbitmq = pkgs.callPackage ./rabbitmq { inherit erlang; };

  solr = pkgs.callPackage ./solr {};
}
