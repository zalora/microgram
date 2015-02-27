{ stdenv, fetchurl, perl, erlangR14, curl, libevent }:

stdenv.mkDerivation rec {
  name = "couchbase-${version}";
  version = "1.8.1";

  src = fetchurl {
    url = "http://packages.couchbase.com/releases/${version}/couchbase-server_src-${version}.tar.gz";
    sha256 = "0fh4nj5q2jvc67fn2v886bir9jp2b8kra0c5j6b3r7b6i3j487py";
  };

  patches = [ ./patch-ep-engine ];

  postPatch = ''
    substituteInPlace bucket_engine/configure --replace Werror Wno-error
    substituteInPlace couchbase-python-client/configure --replace Werror Wno-error
    substituteInPlace ep-engine/configure --replace Werror Wno-error
    substituteInPlace libconflate/configure --replace Werror Wno-error
    substituteInPlace libmemcached/configure --replace Werror Wno-error
    substituteInPlace libvbucket/configure --replace Werror Wno-error
    substituteInPlace membase-cli/configure --replace Werror Wno-error
    substituteInPlace memcached/configure --replace Werror Wno-error
    substituteInPlace memcachetest/configure --replace Werror Wno-error
    substituteInPlace moxi/configure --replace Werror Wno-error
    substituteInPlace ns_server/configure --replace Werror Wno-error
    substituteInPlace portsigar/configure --replace Werror Wno-error
    substituteInPlace sigar/configure --replace Werror Wno-error
    substituteInPlace vbucketmigrator/configure --replace Werror Wno-error
    substituteInPlace workload-generator/configure --replace Werror Wno-error
  '';

  preConfigure = ''
    export LDFLAGS="-pthread"
  '';

  installPhase = ''
    cp -R ./install/ $out
  '';

  buildInputs = [ perl curl libevent ];
  propagatedBuildInputs = [ erlangR14 ];
}
