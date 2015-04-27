{ pkgs, stdenv, fetchurl
, base ? import ./base.nix { inherit pkgs; }
, Gemfile ? import ./Gemfile.nix
}:

let
  inherit (stdenv.lib) concatStringsSep;
  gems = map (gem: fetchurl { inherit (gem) url sha256; }) Gemfile;
in

# This package is actually a "package factory", because we (have to?) configure
# the plugin at installPhase.
config:

stdenv.mkDerivation {
  inherit (base) name src buildInputs;

  installPhase = ''
    cp -R . $out
    cd $out
    export HOME=$out

    cat > config/newrelic_plugin.yml <<EOF
    newrelic:
      license_key: ${config.newrelic.license_key}
      verbose: 0
    agents:
      rabbitmq:
        management_api_url: ${toString config.rabbitmq.management_api_url}
        debug: false
    EOF

    mkdir -p vendor/cache
    ${concatStringsSep ";" (map (x: "ln -s ${x} vendor/cache/${x.name}") gems)}

    ln -s ${./Gemfile.lock} Gemfile.lock

    bundle install --local --deployment
  '';

  meta = {
    homepage = https://github.com/pivotalsoftware/newrelic_pivotal_agent;
    description = "Pivotal Plugins for New Relic Monitoring";
  };
}
