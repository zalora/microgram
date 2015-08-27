# used to be nixops/nix/virtualbox-image-nixops.nix
{ config, pkgs, lib, ... }:

let
  clientKeyPath = "/root/.vbox-nixops-client-key";
in
{
  imports = [
    <nixpkgs/nixos/modules/rename.nix> # services.virtualboxGuest
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
    <nixpkgs/nixos/modules/virtualisation/virtualbox-guest.nix>
    <microgram/nixos/cloud/cloud-config.nix>
    ./vm.nix
  ];

  services.openssh.authorizedKeysFiles = [ ".vbox-nixops-client-key" ];

  boot.vesa = false;

  boot.loader.grub.timeout = 1;

  # VirtualBox doesn't seem to lease IP addresses persistently, so we
  # may get a different IP address if dhcpcd is restarted.  So don't
  # restart dhcpcd.
  systemd.services.dhcpcd.restartIfChanged = false;

  nix = {
    extraOptions = ''
      allow-unsafe-native-code-during-evaluation = true
    '';
  };

  users.extraUsers.root = lib.mkDefault {
    hashedPassword = null;
    password = "root";
  };
  services.openssh.passwordAuthentication = lib.mkDefault true;
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.openssh.challengeResponseAuthentication = lib.mkDefault true;
}
