## NixOS Images

Opinionated base NixOS configuration suitable for cloud deployments
based on [EC2 instance-store instances](env-ec2.nix)
and [VirtualBox](env-virtualbox.nix) for development/testing.

Quick start (you need `<nixpkgs>` in your `$NIX_PATH` to build this)

Build a NixOS nix package (also known as toplevel system closure) locally:

```bash
nix-build -A nginx-nixos.system examples/images.nix
```

Build on `builder.example.com` and install to an existing NixOS host `www.example.com`:

```bash
upcast build-remote -t builder.example.com -A nginx-nixos.system images.nix \
    | xargs -tn1 upcast install -f builder.example.com -t www.example.com
```

Build and upload AMIs or OVAs (if you don't have a remote builder, substitute `upcast build-remote -t builder.example.com` with `nix-build`):

```bash
# builds an OVA (exported by VirtualBox)
upcast build-remote -t builder.example.com -A nginx-vm.ova images.nix

# builds a VDI (to be used with VirtualBox), might be faster as doesn't have VirtualBox as a dependency
upcast build-remote -t builder.example.com -A nginx-vm.ova images.nix

export AWS_ACCOUNT_ID=...
export AWS_X509_CERT=...
export AWS_X509_KEY=...
export AWS_ACCESS_KEY=...
export AWS_SECRET_KEY=...

# builds a base instance-store AMI
upcast build-remote -t builder.example.com -A nginx-ami.ami images.nix

# builds and registers an AMI on AWS
upcast build-remote -t builder.example.com -A nginx-ami.register images.nix
```
