{ goPackages, fetchgit, fetchFromGitHub, runCommand }:


let
  iniflags = goPackages.buildGoPackage rec {
    rev = "7e26b9281b070a9562df8694980c68e56d298c36";
    name = "iniflags-${rev}";
    goPackagePath = "github.com/vharitonsky/iniflags";
    src = fetchgit {
      url = "https://${goPackagePath}";
      inherit rev;
      sha256 = "8643aafd59293ff4176cbae2c883563d274cabb5f83b7ce6210f97ecfbd38518";
    };
  };

  gomemcache = goPackages.buildGoPackage rec {
    rev = "72a68649ba712ee7c4b5b4a943a626bcd7d90eb8";
    name = "gomemcache-${rev}";
    goPackagePath = "github.com/bradfitz/gomemcache/memcache";
    src = fetchgit {
      url = "https://github.com/bradfitz/gomemcache";
      inherit rev;
      sha256 = "5fafdc33f130528127b8cdee42d36e47d80b2dcaff6052cf22f50c5f490293cb";
    };
  };
in
goPackages.buildGoPackage rec {
  rev = "116340830b56cd4a766a1a0a68826dff4155f16e";
  name = "ybc-${rev}";
  goPackagePath = "github.com/valyala/ybc";
  buildInputs = [ iniflags gomemcache ];
  src = fetchFromGitHub {
    inherit rev;
    owner = "valyala";
    repo = "ybc";
    sha256 = "0fy42716qrcfi4s7g3fh6jhcdd4svbabfi5qfh8620hc56f2h2nn";
  };
}
