{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOverride mkDefault;
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
  };
}
