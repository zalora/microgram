{ config, pkgs, lib, ... }:
{
  system.activationScripts.buildSigningKeys = ''
    if [[ ! -f /etc/nix/signing-key.sec ]]; then
      mkdir -p /etc/nix
      ${pkgs.openssh}/bin/ssh-keygen -b 4096 -N "" -f /etc/nix/signing-key.sec
      rm /etc/nix/signing-key.sec.pub
      ${pkgs.openssl}/bin/openssl rsa -in /etc/nix/signing-key.sec -pubout > /etc/nix/signing-key.pub
      chmod a-rwx,g+r /etc/nix/signing-key.*
      chown nobody:users /etc/nix/signing-key.*
    fi
  '';
}
