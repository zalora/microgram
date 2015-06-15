{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOverride mkDefault optionalString mkForce;
in
{
  imports = [
    ./amazon-image.nix
    <microgram/nixos/cloud-config.nix>
  ];

  config = {
    nixpkgs.system = mkOverride 100 "x86_64-linux";

    #boot.loader.grub.extraPerEntryConfig = mkIf isEc2Hvm ( mkOverride 10 "root (hd0,0)" );

    ec2.metadata = mkDefault true;

    # By default, 'fetch-ec2-data' assigns hostnames and writes SSH host keys
    # from user data. We don't want that.
    systemd.services."fetch-ec2-data".script = mkForce (''
      ip route del blackhole 169.254.169.254/32 || true
    '' + optionalString (!config.ec2.metadata) ("\n" + ''
      # Since the user data is sensitive, prevent it from being
      # accessed from now on.
      ip route add blackhole 169.254.169.254/32
    ''));
  };
}
