{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; config.allowUnfree = true; }
, ...
}:

let
  inherit (pkgs)
    lib
    pythonPackages perlPackages haskellPackages
    stdenv fetchurl;
  inherit (lib) overrideDerivation;
in rec {
  angel = pkgs.haskellPackages.callPackage ./angel {};

  couchbase = pkgs.callPackage ./couchbase {};

  damemtop = pkgs.writeScriptBin "damemtop" ''
    #!${pkgs.bash}/bin/bash
    exec env PERL5LIB=${lib.makePerlPath (with perlPackages; [ AnyEvent GetoptLong TermReadKey YAML ])} \
      ${pkgs.perl}/bin/perl ${./memcached/damemtop} "$@"
  '';

  curl-loader = pkgs.callPackage ./curl-loader {};

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

  go = pkgs.callPackage ./go/1.4.nix {};

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

  ImageMagick = pkgs.callPackage ./ImageMagick {};

  mariadb = pkgs.callPackage ./mariadb {};

  memcached-tool = pkgs.writeScriptBin "memcached-tool" ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.perl}/bin/perl ${./memcached/memcached-tool} "$@"
  '';

  mysql55 = pkgs.callPackage ./mysql/5.5.x.nix {};

  newrelic-java = pkgs.fetchurl {
    url = "https://download.newrelic.com/newrelic/java-agent/newrelic-agent/3.12.0/newrelic-agent-3.12.0.jar";
    sha256 = "1ssr7si7cbd1wg39lkgsi0nxnh5k0xjsbcjsnn33jm2khx7q0cji";
  };

  newrelic-mysql-plugin = pkgs.srcOnly rec {
    name = "newrelic_mysql_plugin-2.0.0";
    src = pkgs.fetchurl {
      url = "https://github.com/newrelic-platform/newrelic_mysql_java_plugin/raw/master/dist/${name}.tar.gz";
      sha256 = "158afq1q11bwjzcrsm860n8vj1xzdasql86b9qpwyhs4czjy0grd";
    };
  };

  newrelic-php = pkgs.callPackage ./newrelic-php {};

  newrelic-python = import ./newrelic-python { inherit pkgs; };

  newrelic-sysmond = pkgs.callPackage ./newrelic-sysmond {};

  nginx = overrideDerivation (pkgs.nginx.override { ngx_lua = true; }) (args: {
    configureFlags = args.configureFlags ++ ["--with-http_stub_status_module"];
  });

  percona-toolkit = import ./percona-toolkit { inherit perlPackages fetchurl; };

  pivotal_agent = pkgs.callPackage ./pivotal_agent {};

  rabbitmq = pkgs.callPackage ./rabbitmq { inherit erlang; };

  solr = pkgs.callPackage ./solr {};

  statsd = pythonPackages.buildPythonPackage rec {
    name = "statsd-3.0.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/statsd/${name}.tar.gz";
      md5 = "af256148584ed4daa66f50c30b5c1f95";
    };

    doCheck = false;

    propagatedBuildInputs = with pythonPackages; [];

    meta = with stdenv.lib; {
      homepage = https://github.com/jsocol/pystatsd;
      license = licenses.mit;
    };
  };

  thumbor = (import ./thumbor { inherit pkgs newrelic-python statsd; }).thumbor;
}
