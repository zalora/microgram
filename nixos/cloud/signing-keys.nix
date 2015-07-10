{ config, pkgs, lib, ... }:
{
  system.activationScripts.buildSigningKeys = lib.stringAfter ["users"] ''
    if [[ ! -f /etc/nix/signing-key.sec ]]; then
      mkdir -p /etc/nix
      # ssh-keygen needs users to exist
      ${pkgs.openssh}/bin/ssh-keygen -b 4096 -N "" -f /etc/nix/signing-key.sec
      rm -f /etc/nix/signing-key.sec.pub
      ${pkgs.openssl}/bin/openssl rsa -in /etc/nix/signing-key.sec -pubout > /etc/nix/signing-key.pub
      chmod a-rwx,g+r /etc/nix/signing-key.*
      chown nobody:users /etc/nix/signing-key.*
    fi
  '';
}
