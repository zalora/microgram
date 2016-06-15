{ stdenv, phpPackages }:

stdenv.lib.overrideDerivation phpPackages.memcache (_: {
  patches = [ ./memcache-faulty-inline.diff ];
})
