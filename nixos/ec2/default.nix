{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOverride mkDefault optionalString mkForce;
in
{
  imports = [
    ./amazon-image.nix
    ./ami-ebs.nix
    ./ami-s3.nix
    <microgram/nixos/cloud/cloud-config.nix>
    <nixpkgs/nixos/modules/virtualisation/ec2-data.nix> # fetch-ec2-data and print-host-key
  ];

  config = {
    nixpkgs.system = mkOverride 100 "x86_64-linux";

    #boot.loader.grub.extraPerEntryConfig = mkIf isEc2Hvm ( mkOverride 10 "root (hd0,0)" );

    # By default, 'fetch-ec2-data' assigns hostnames and writes SSH host keys
    # from user data. We don't want that.
    systemd.services."fetch-ec2-data".script = mkForce ''
      wget="wget -q --retry-connrefused -O -"

      # Don't download the SSH key if it has already been injected
      # into the image (a Nova feature).
      if ! [ -e /root/.ssh/authorized_keys ]; then
          echo "obtaining SSH key..."
          mkdir -m 0700 -p /root/.ssh
          $wget http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key > /root/key.pub
          if [ $? -eq 0 -a -e /root/key.pub ]; then
              if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                  cat /root/key.pub >> /root/.ssh/authorized_keys
                  echo "new key added to authorized_keys"
              fi
              chmod 600 /root/.ssh/authorized_keys
              rm -f /root/key.pub
          fi
      fi
    '';
  };
}
