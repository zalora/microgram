{ pkgs ? import <nixpkgs> {}
, base ? import ./base.nix { inherit pkgs; }
}:

pkgs.stdenv.mkDerivation {
  inherit (base) name src buildInputs;

  installPhase = ''
    cp -R . $out
    cd $out
    export HOME=$out
    bundle install --verbose --local
    ruby ${./generate_nix_requirements.rb}
  '';

  __noChroot = true;
}
