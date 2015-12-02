let
  inherit (import <microgram/sdk.nix>) pkgs;
  testlib = import ./lib.nix;

  virtualbox = import <microgram/nixos> {
    configuration = {
      imports = [
        <microgram/nixos/virtualbox>
      ];
    };
  };

  ec2 = import <microgram/nixos> {
    configuration = {
      imports = [
        <microgram/nixos/ec2>
      ];
    };
  };

  qemu = import <microgram/nixos> {
    configuration = {
      imports = [
        <microgram/nixos/qemu>
      ];
    };
  };
in
rec {
  ebs-ami-builder = ec2.config.system.build.aminator;

  s3-bundle = ec2.config.system.build.s3Bundle;
  s3-ami = ec2.config.system.build.s3Register;

  vdi = virtualbox.config.system.build.vdi;
  ova = virtualbox.config.system.build.ova;

  qemu-test = testlib.runInMachine {
    nixos = qemu;
    drv = pkgs.runCommand "test" {} ''
      export PATH=/run/current-system/sw/bin
      ps -ef | grep systemd | tee $out
    '';
  };
}
