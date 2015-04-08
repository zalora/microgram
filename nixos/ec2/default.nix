{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOverride mkDefault;
  inherit (import <microgram/nixos/kernel> { inherit pkgs; }) cleanLinux;
  cloudKernel = pkgs.linuxPackages_3_18 // { kernel = cleanLinux pkgs.linux_3_18 true; };
in
{
  imports = [
    ./amazon-image.nix
    <microgram/nixos/cloud-config.nix>
  ];

  config = {
    nixpkgs.system = mkOverride 100 "x86_64-linux";
    boot.kernelPackages = cloudKernel;

    #boot.loader.grub.extraPerEntryConfig = mkIf isEc2Hvm ( mkOverride 10 "root (hd0,0)" );

    ec2.metadata = mkDefault true;
  };
}
