## python2nix

Helper to build python [nix packages](https://github.com/NixOS/nixpkgs) that generates nix-expressions.

Quick start:

* `python -mpython2nix thumbor`
* double-check dependencies in nixpkgs
* re-run for missing dependencies
* copy-paste
* ???
* PROFIT!

Don't consider these scripts to be stable.

### Known issues

* Needs pip==1.5.6 to work.
* Apparently doesn't handle `tests_require`.
