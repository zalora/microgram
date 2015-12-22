## Microgram

Microgram is a project that aims to provide tooling for accomodating end-to-end lifecycle of cloud-native applications.

Microgram uses Nix for expressing deployment topologies and packaging software
using the [Nix package manager](http://nixos.org/nix/).

Watch this space for updates.

<script async class="speakerdeck-embed" data-id="b868a08a6a434548bf6317cd26fcb444" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

### NixOS

Microgram includes opinionated [NixOS 15.09](https://github.com/nixos/nixpkgs/tree/release-15.09) configuration targeted for deployments in IaaS environments.

Currently supported backends: EC2 AMI (EBS and instance-store), QEMU (automated testing), VirtualBox (works in other providers that support OVAs, like VMWare).

* [nixos/](nixos/) - opinionated base NixOS configuration, used to be a part of [Upcast](https://github.com/zalora/upcast)

To test images of Nginx:

You need `<nixpkgs>` in your `$NIX_PATH` to build, branch `release-15.09`.
If you don't have a remote builder, substitute `upcast build -t builder.example.com` with `nix-build`.

```bash
# builds an OVA (exported by VirtualBox)
upcast build -t builder.example.com -A ova tests/nginx.nix

# builds a VDI (to be used with VirtualBox), might be faster as it doesn't have VirtualBox as a dependency
upcast build -t builder.example.com -A vdi tests/nginx.nix

# builds and runs a test in qemu
upcast build -t builder.example.com -A qemu-test tests/nginx.nix

export AWS_ACCOUNT_ID=...
export AWS_X509_CERT=...
export AWS_X509_KEY=...
export AWS_ACCESS_KEY=...
export AWS_SECRET_KEY=...

# bundles an instance-store AMI
upcast build -t builder.example.com -A s3-bundle tests/nginx.nix

# builds a script that sets up an EBS AMI
upcast build -t builder.example.com -A ebs-ami-builder tests/nginx.nix
```

### Packaging software

* [to-nix/python](to-nix/python) - Python packaging documentation and tools (previously known as python2nix)
* [to-nix/haskell](to-nix/haskell) - Haskell packaging documentation for programs using Cabal
* [to-nix/golang](to-nix/golang) - Go packaging documentation for Nix

### Utility scripts

* [bin/](bin) - Lightweight Nix-related tooling

### Additional tooling

Other platform-related projects are:

* [Defnix](https://github.com/zalora/defnix) - aims to replace some core NixOS components that were not designed for our use cases and provides
a novel interface to supersede NixOS modules. It uses a lot of metaprogramming and [nix-exec](https://github.com/shlevy/nix-exec) for running effectful nix builds.
* [Upcast](https://github.com/zalora/upcast) - provides AWS infrastructure provisioning (insipired by NixOps but decoupling infrastructure from software) and tooling that extends nix-build.
