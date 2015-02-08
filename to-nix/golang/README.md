## Packaging Go apps

It's quite easy to package Go apps with Nix if you're using [Godep](https://github.com/tools/godep).

[example.nix](example.nix) is meant to be copy-pasted into your packages
collection with subsequent minor edits.

```nix
  pkgs.callPackage ./example.nix { src = <path-to-my-app-sources>; }
```
