{ diagnostics, name ? "wtf" }:
let
  inherit (import <microgram/sdk.nix>) lib sdk pkgs;
  inherit (pkgs) stdenv;
  inherit (lib) types mkOption concatStrings mapAttrsToList mapAttrs;

  eval = lib.evalModules { modules = [ module ]; };
  diags = eval.config.diagnostics;

  module = {
    options = {
      diagnostics = mkOption {
        type = types.attrsOf (types.submodule (import ./api.nix));
        default = diagnostics;
      };

      paths = {
        wtf = mkOption { type = types.path; default = wtf; };
        wtfdb = mkOption { type = types.path; default = wtfdb; };
      };

      test = mkOption {
        type = types.attrsOf types.str;
        default = mapAttrs (_: diag: "${wtf}/bin/wtf ${diag.name}") diags;
      };

      wait = mkOption {
        type = types.attrsOf types.str;
        default = mapAttrs (_: diag: "${wtf}/bin/wtf -w ${diag.name}") diags;
      };
    };
  };

  wtfdb = sdk.writeText "wtfdb.json" (builtins.toJSON diags);

  wtfenv = pkgs.buildEnv {
    name = "${name}-env";
    paths = with sdk; [
      coreutils findutils inetutils gawk gnused
      jq curl put-metric netcat-openbsd ntp
    ];
  };

  wtf = stdenv.mkDerivation {
    inherit name;

    buildCommand = ''
      mkdir -p $out/{bin,checks}
      substituteAll $wtf $out/bin/wtf
      substituteAll $checkWrapper $out/bin/check-wrapper
      chmod +x $out/bin/{wtf,check-wrapper}

      ${concatStrings (mapAttrsToList (n: c: ''
        cp -v "${c.wtf-wrapper}" "$out/checks/${n}"
      '') diags)}
    '';

    wtf = ./wtf;
    checkWrapper = ./check-wrapper;

    inherit wtfenv wtfdb;
  };
in eval
