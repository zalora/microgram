let
  inherit (import <microgram/sdk.nix>) lib sdk;
  inherit (lib) mapAttrsToList concatStringsSep makeSearchPath;
in rec {

  makeBinPath = makeSearchPath "bin";

  mapcats = f: x: concatStringsSep "\n" (mapAttrsToList f x);
}
