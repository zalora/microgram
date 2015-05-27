{ configuration
, system ? "x86_64-linux"
}:

let
  eval-config = import <nixpkgs/nixos/lib/eval-config.nix>;
  baseModules = [stub-module]
             ++ [<microgram/nixos/ntpd.nix>]
             ++ import <microgram/nixos/vendor-module-list.nix>;

  lib = import <nixpkgs/lib>;

  stub = with lib; mkOption {
    type = types.attrsOf types.unspecified;
    default = {
      enable = false;
      nssmdns = false;
      nsswins = false;
      syncPasswordsByPam = false;
      isContainer = false;
      devices = [];
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
      boot.initrd.luks = stub;
      networking.wireless = stub;
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

  vm-modules = [
    configuration
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    ({ virtualisation.graphics = false; })
  ];

  virt = (eval-config {
    inherit system baseModules;
    modules = vm-modules;
  });

  virt-bootloader = eval-config {
    inherit system baseModules;
    modules = vm-modules ++ [ { virtualisation.useBootLoader = true; } ];
  };
in
rec {
  inherit (eval) config options;

  system = eval.config.system.build.toplevel;

  vm = virt.config.system.build.vm;
  qemu = vm;

  vmWithBootLoader = virt-bootloader.config.system.build.vm;
}
