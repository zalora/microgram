## Zalora Platform

Converge diverse software development and deployment practices under
an interface that lets developers and operations reuse
effort and write code that can be evaluated to a cloud or on-premise
deployment for various backends (VirtualBox, Docker containers, AWS
EC2, managed hosting environments, etc).

Zalora Platform uses Nix for expressing deployment topologies and packaging software
using the [Nix package manager](http://nixos.org/nix/).
Other platform-related work is available as [Defnix](https://github.com/zalora/defnix)
and [Upcast](https://github.com/zalora/upcast).

### Packaging software

* [to-nix/ruby](to-nix/ruby) - Ruby packaging documentation and tools
* [to-nix/python](to-nix/python) - Python packaging documentation and tools (previously known as python2nix)
* [to-nix/haskell](to-nix/haskell) - Haskell packaging documentation
* `to-nix/golang` - TBA
* `to-nix/docker` - TBA (using lightweight docker images as a software delivery unit)

### NixOS

Zalora is using [NixOS](https://github.com/nixos/nixpkgs/tree/release-14.12) as the core
codebase for building AMIs and other image types for cloud provides, and Nix packages collection
as the core package base.

Zalora Platform includes an [optinionated base NixOS configuration](nixos/) (that used to be part of [Upcast](https://github.com/zalora/upcast))
that has been used for AWS deployments for several months.

```bash
# builds a base AMI
nix-build -A image nixos/ami.nix
# builds a base VirtualBox image
nix-build -A vbox nixos/ami.nix
```
