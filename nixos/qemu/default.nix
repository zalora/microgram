{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    <microgram/nixos/cloud/cloud-config.nix>
    <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
  ];

  networking.hostName = mkForce "client"; # referenced in perl code as $client
  nix.readOnlyStore = mkForce false;
  # test framework mounts 9p *before* tmpfs, so 9p stuff gets masked
  boot.tmpOnTmpfs = mkForce false;
  # .. or removed
  boot.cleanTmpDir = mkForce false;

  virtualisation = {
    memorySize = 4096;
    diskSize = 8192;
    graphics = false;
    #useBootLoader = true;
  };
}
