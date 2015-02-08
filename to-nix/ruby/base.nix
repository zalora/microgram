{ pkgs }:

{
  name = "pivotal_agent-1.0.5";

  src = pkgs.fetchgit {
    url = https://github.com/pivotalsoftware/newrelic_pivotal_agent;
    rev = "0b14856792b47280e598b0275725a5ddefbee58a";
    sha256 = "d9d065c44dfdc1b219847222fdbdda10feb9cece8b5b91bbdb57087040549d3f";
  };

  buildInputs = [
    pkgs.ruby
    pkgs.rubyLibs.bundler
    pkgs.rubyLibs.newrelic_plugin
    pkgs.rubyLibs.redis
    pkgs.rubyLibs.rabbitmq_manager
  ];
}
