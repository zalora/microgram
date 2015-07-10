{ config
, lib
, ... }:
let
  inherit (import <microgram/sdk.nix>) pkgs ugpkgs;
  inherit (lib) optionalString;
in
(as: { config.system.build = as; }) rec {
  # Should be rebuilt on every ug/nixpkgs bump. Remove this eventually.
  aminator = aminator1 "snap-e665e8d3";

  # The builder instance IAM role must be able to manage EBS volumes and register images.
  # Unlike its ami-s3 cousin, this script doesn't to builds within derivations, but generates
  # a script that needs to run in a privileged environment.
  aminator1 = sdk-snapshot:
    let
      toplevel = config.system.build.toplevel;
      graph = ugpkgs.fns.exportGraph toplevel;
    in pkgs.runCommand "aminate-ebs" {
      __noChroot = true;
      preferLocalBuild = true;
    } ''
      echo env graph=${graph} toplevel=${toplevel} ${
        optionalString (sdk-snapshot != null) "baseSnapshot=${sdk-snapshot}"
      } ${ugpkgs.mkebs} | tee $out
      chmod +x $out
    '';
}
