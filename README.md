## Microgram

Bring your own web app store to the Internets.

Microgram uses Nix for expressing deployment topologies and packaging software
using the [Nix package manager](http://nixos.org/nix/).

### Packaging software

* [to-nix/ruby](to-nix/ruby) - Ruby packaging documentation and tools
* [to-nix/python](to-nix/python) - Python packaging documentation and tools (previously known as python2nix)
* [to-nix/haskell](to-nix/haskell) - Haskell packaging documentation for programs using Cabal
* [to-nix/golang](to-nix/golang) - Go packaging documentation for Nix
* `to-nix/docker` - TBA (using lightweight docker images as a software delivery unit)

### Utility scripts

* [bin/](bin) - Lightweight Nix-related tooling

### NixOS

Microgram is based on [NixOS](https://github.com/nixos/nixpkgs/tree/release-14.12) as the core
codebase for building AMIs and other image types for cloud provides, and Nix packages collection
as the core package base.

Examples are inside.

* [nixos/](nixos/) - opinionated base NixOS configuration, used to be a part of [Upcast](https://github.com/zalora/upcast)

### Additional tooling

Other platform-related projects are:

* [Defnix](https://github.com/zalora/defnix) - aims to replace some core NixOS components that were not designed for our use cases and provides
a novel interface to supersede NixOS modules. It uses a lot of metaprogramming and [nix-exec](https://github.com/shlevy/nix-exec) for running effectful nix builds.
* [Upcast](https://github.com/zalora/upcast) - provides AWS infrastructure provisioning (insipired by NixOps but decoupling infrastructure from software) and tooling that extends nix-build.
