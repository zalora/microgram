# Packaging Haskell apps

Start with [cabal2nix](https://github.com/NixOS/cabal2nix).

The workflow roughly looks like:

```bash
$ cabal2nix --sha256=ignoreme file:///path/to/package.cabal > ./my-app/default.nix
$ vim ./my-app/default.nix # remove sha256 stuff and add src reference:
#     src = git-repo-filter <my-app>;

# now add to the packages attrset:
   my-app = pkgs.haskellPackages.callPackage ./my-app {};
```
