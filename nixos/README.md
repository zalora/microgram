## NixOS Images

Opinionated base NixOS configuration suitable for cloud deployments
based on [EC2 instance-store instances](env-ec2.nix)
and [VirtualBox](env-virtualbox.nix) for development/testing.

Quick start:

```nix
{
  # you need <nixpkgs> in your $NIX_PATH to build this
  # <platform/nixos> is a drop-in replacement for <platform/nixos>
  just-nginx = (import <upcast/nixos> {
    configuration = { config, pkgs, lib, ... }: {
      config.services.nginx.enable = true;
    };
  }).system;
}
```

Build and install in an ad-hoc way:

```bash
upcast build-remote -t $BUILD_BOX_IP -A just-nginx infra.nix \
    | xargs -tn1 upcast install -f $BUILD_BOX_IP -t $TARGET_NODE
```

Building images:

```bash
# builds a base AMI
nix-build -A image nixos/ami.nix

# builds a base VirtualBox image
nix-build -A vbox nixos/ami.nix
```
