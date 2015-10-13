{ pkgs, stdenv, ruby, bundler }:

let
  version = "1.0.5";

  env = pkgs.bundlerEnv {
    name = "pivotal_agent-gems-${version}";
    inherit (pkgs) ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in

stdenv.mkDerivation {
  name = "pivotal_agent-${version}";

  src = pkgs.fetchgit {
    url = https://github.com/pivotalsoftware/newrelic_pivotal_agent;
    rev = "0b14856792b47280e598b0275725a5ddefbee58a";
    sha256 = "d9d065c44dfdc1b219847222fdbdda10feb9cece8b5b91bbdb57087040549d3f";
  };

  buildInputs = [
    ruby
    bundler
  ];

  GEM_HOME = "${env}/${ruby.gemPath}";

  buildPhase = ''
    cat > config/newrelic_plugin.yml <<EOF
    newrelic:
      license_key: FILLMEIN
      verbose: 0
    agents:
      rabbitmq:
        management_api_url: http://admin:password@localhost:15672
        debug: false
    EOF
    HOME=$out bundle install --local
  '';

  installPhase = ''
    cp -R . $out
    cat > $out/profile <<EOF
    export GEM_HOME; GEM_HOME=$GEM_HOME
    export PATH; PATH=${stdenv.lib.makeSearchPath "bin" (with pkgs; [
      ruby
      bundler
    ])}
    EOF
  '';

  meta = {
    homepage = https://github.com/pivotalsoftware/newrelic_pivotal_agent;
    description = "Pivotal Plugins for New Relic Monitoring";
  };
}
