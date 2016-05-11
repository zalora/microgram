# This file is mostly stoken from
# https://github.com/NixOS/nixpkgs/blob/74139a6b585d2b8bd0922ca6b0baed79f2f5cc66/pkgs/top-level/python-packages.nix

{ pkgs }:

with pkgs.lib;

let

  self = pkgs.pythonPackages;
  inherit (self) buildPythonPackage;

in rec {

  acme = buildPythonPackage rec {
    inherit (pkgs.letsencrypt) src version;

    name = "acme-${version}";

    propagatedBuildInputs = with self; [
      cryptography pyasn1 pyopenssl pyRFC3339 pytz requests2 six werkzeug mock
      ndg-httpsclient
    ];

    buildInputs = with self; [ nose ];

    sourceRoot = "letsencrypt-${version}/acme";
  };

  ndg-httpsclient = buildPythonPackage rec {
    version = "0.4.0";
    name = "ndg-httpsclient-${version}";

    propagatedBuildInputs = with self; [ pyopenssl ];

    src = pkgs.fetchFromGitHub {
      owner = "cedadev";
      repo = "ndg_httpsclient";
      rev = "v${version}";
      sha256 = "1prv4j3wcy9kl5ndd5by543xp4cji9k35qncsl995w6sway34s1a";
    };

    # uses networking
    doCheck = false;

    meta = {
      homepage = https://github.com/cedadev/ndg_httpsclient/;
      description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
      license = licenses.bsd2;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  pyRFC3339 = buildPythonPackage rec {
    name = "pyRFC3339-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyRFC3339/pyRFC3339-${version}.tar.gz";
      sha256 = "1pp648xsjaw9h1xq2mgwzda5wis2ypjmzxlksc1a8grnrdmzy155";
    };

    propagatedBuildInputs = with self; [ pytz ];
    buildInputs = with self; [ nose ];
  };

  pyopenssl = buildPythonPackage rec {
    name = "pyopenssl-${version}";
    version = "0.15.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-${version}.tar.gz";
      sha256 = "0wnnq15rhj7fhdcd8ycwiw6r6g3w9f9lcy6cigg8226vsrq618ph";
    };

    # 12 tests failing, 26 error out
    doCheck = false;

    propagatedBuildInputs = [ self.cryptography self.pyasn1 self.idna ];
  };

}
