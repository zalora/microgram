{ pkgs, stdenv, fetchurl
, base ? import ./base.nix { inherit pkgs; }
, Gemfile ? import ./Gemfile.nix
}:

let
  inherit (stdenv.lib) concatStringsSep;
  gems = map (gem: fetchurl { inherit (gem) url sha256; }) Gemfile;
in
stdenv.mkDerivation {
  inherit (base) name src buildInputs;

  installPhase = ''
    cp -R . $out
    cd $out
    export HOME=$out

    cat > config/newrelic_plugin.yml <<EOF
    newrelic:
      license_key: FILLMEIN
      verbose: 0
    agents:
      rabbitmq:
        management_api_url: http://admin:password@localhost:15672
        debug: false
    EOF

    echo gem "'json'" >> Gemfile

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
