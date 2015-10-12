let
  inherit (import <microgram/sdk.nix>) lib sdk;
  inherit (lib) mapAttrsToList concatStringsSep makeSearchPath;
in rec {

  makeBinPath = makeSearchPath "bin";

  exportSessionVariables = mapcats (k: v: "export ${k}=${v}") {
    TZDIR = "${sdk.tzdata}/share/zoneinfo";
    # https://github.com/NixOS/nixpkgs/blob/release-15.09/nixos/modules/security/ca.nix#L67-L71
    SSL_CERT_FILE = "${sdk.cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${sdk.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  mapcats = f: x: concatStringsSep "\n" (mapAttrsToList f x);
}
