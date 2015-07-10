let
  inherit (import <microgram/sdk.nix>) sdk pkgs lib;
  testing = import <nixpkgs/nixos/lib/testing.nix> {
    inherit (pkgs) system;
    minimal = true;
  };
in
{
  runInMachine =
    { drv
    , nixos
    , preBuild ? ""
    , postBuild ? ""
    }:
    let
      buildrunner = sdk.writeScript "vm-build" ''
        source $1

        ${sdk.coreutils}/bin/mkdir -p $TMPDIR
        cd $TMPDIR

        $origBuilder $origArgs

        exit $?
      '';

      testScript = ''
        sub run {
          my ($command) = @_;
          my ($status, $out) = $client->execute($command);
          $client->log("debug($command): $out");
          if ($status != 0) {
            die "run failed (status $status)\n";
          }
        }

        startAll;
        $client->waitForUnit("multi-user.target");
        ${preBuild}
        run("${sdk.bash}/bin/bash ${buildrunner} /tmp/xchg/saved-env >&2");
        ${postBuild}
        $client->succeed("sync");
      '';

      vmRunCommand = sdk.writeText "vm-run" ''
        set -e
        #${sdk.coreutils}/bin/mkdir -v $out
        echo $PWD
        ${sdk.coreutils}/bin/mkdir -vp $PWD/vm-state-client/xchg
        export > $PWD/vm-state-client/xchg/saved-env
        export tests='${testScript}'
        ${testing.testDriver}/bin/nixos-test-driver ${nixos.config.system.build.vm}/bin/run-*-vm
      ''; # */

    in
      lib.overrideDerivation drv (attrs: {
        requiredSystemFeatures = [ "kvm" ];
        builder = "${sdk.bash}/bin/sh";
        args = ["-e" vmRunCommand];
        origArgs = attrs.args;
        origBuilder = attrs.builder;
      });
}
