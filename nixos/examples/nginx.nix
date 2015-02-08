rec {
  nginx-module = { config, ... }: {
    config.services.nginx.enable = true;
  };

  # <platform/nixos> is a thin wrapper around <nixpkgs/nixos>
  nginx-nixos = import <platform/nixos> { configuration = nginx-module; };

  nginx-ami = import <platform/nixos/backends/ami.nix> {
    modules = [ nginx-module ];
    upload-context = rec {
      region = "ap-southeast-1";
      bucket = "platform-${region}";
    };
  };

  nginx-vm = import <platform/nixos/backends/vm.nix> {
    modules = [ nginx-module ];
    fileName = "nginx.ova";
    vmName = "Nginx on NixOS Platform";
  };
}
