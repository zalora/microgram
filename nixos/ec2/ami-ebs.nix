{ config
, lib
, ... }:
let
  inherit (import <microgram/sdk.nix>) pkgs ugpkgs;
  inherit (lib) optionalString;
in
(as: { config.system.build = as; }) rec {
  # The builder instance IAM role must be able to manage EBS volumes and register images.
  # Unlike its ami-s3 cousin, this script doesn't to builds within derivations, but generates
  # a script that needs to run in a privileged environment.
  aminator =
    let
      toplevel = config.system.build.toplevel;
      graph = ugpkgs.fns.exportGraph toplevel;
    in pkgs.runCommand "aminate-ebs" {
      __noChroot = true;
      preferLocalBuild = true;
    } ''
      echo env graph=${graph} toplevel=${toplevel} ${ugpkgs.mkebs} | tee $out
      chmod +x $out
    '';
}
