{ configuration
, system ? "x86_64-linux"
}:

let
  eval-config = import <nixpkgs/nixos/lib/eval-config.nix>;
  baseModules = [stub-module] ++ import <platform/nixos/vendor-module-list.nix>;

  lib = import <nixpkgs/lib>;

  stub = with lib; mkOption {
    type = types.attrsOf types.unspecified;
    default = {
      enable = false;
      nssmdns = false;
      nsswins = false;
      syncPasswordsByPam = false;
      isContainer = false;
    };
  };

  stub-module = {
    options = {
      services.xserver = stub;
      services.bind = stub;
      services.dnsmasq = stub;
      services.avahi = stub;
      services.samba = stub;
      security.grsecurity = stub;
      users.ldap = stub;
      krb5 = stub;
      powerManagement = stub;
      security.pam.usb = stub;
      boot.isContainer = lib.mkOption { default = false; };
    };
    config = {
      powerManagement.enable = false;
      powerManagement.resumeCommands = "";
      powerManagement.powerUpCommands = "";
      powerManagement.powerDownCommands = "";
    };
  };

  eval = eval-config {
    inherit system baseModules;
    modules = [ configuration ];
  };

  inherit (eval) pkgs;

  vm-modules = [ configuration <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix> ];

  vm = (eval-config {
    inherit system baseModules;
    modules = vm-modules;
  }).config;

  vm-bootloader = (eval-config {
    inherit system baseModules;
    modules = vm-modules ++ [ { virtualisation.useBootLoader = true; } ];
  }).config;

in
{
  inherit (eval) config options;

  system = eval.config.system.build.toplevel;

  vm = vm.config.system.build.vm;

  vmWithBootLoader = vm-bootloader.system.build.vm;
}
