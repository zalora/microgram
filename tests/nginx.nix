let
  inherit (import <microgram/sdk.nix>) pkgs;
  testlib = import ./lib.nix;

  nginx-module = { config, ... }: {
    imports = [
      <nixpkgs/nixos/modules/services/web-servers/nginx>
    ];
    config.services.nginx.enable = true;
  };

  virtualbox = import <microgram/nixos> {
    configuration = {
      imports = [
        nginx-module
        <microgram/nixos/virtualbox>
      ];
    };
  };

  ec2 = import <microgram/nixos> {
    configuration = {
      imports = [
        nginx-module
        <microgram/nixos/ec2>
      ];
    };
  };

  qemu = import <microgram/nixos> {
    configuration = {
      imports = [
        nginx-module
        <microgram/nixos/qemu>
      ];
    };
  };
in
rec {
  ebs-ami-builder = ec2.config.system.build.aminator1 null;
  #ebs-ami-builder' = ec2.config.system.build.aminator1 "snap-xxx";

  s3-bundle = ec2.config.system.build.s3Bundle;
  s3-ami = ec2.config.system.build.s3Register;

  vdi = virtualbox.config.system.build.vdi;
  ova = virtualbox.config.system.build.ova;

  qemu-test = testlib.runInMachine {
    nixos = qemu;
    drv = pkgs.runCommand "test" {} ''
      export PATH=/run/current-system/sw/bin
      ps -ef | grep nginx | tee $out
    '';
  };
}
