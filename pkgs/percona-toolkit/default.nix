{ perlPackages, fetchurl, makeWrapper }:

perlPackages.buildPerlPackage rec {
  version = "2.2.16";
  name = "percona-toolkit-${version}";

  src = fetchurl {
    url = "http://www.percona.com/redir/downloads/percona-toolkit/${version}/tarball/${name}.tar.gz";
    sha256 = "0jk5xrrxy0p92cwpz926xpx5r79lma7ly44rkn9qp3ca0wwg9zwb";
  };

  doCheck = false;
  buildInputs = [ perlPackages.DBI perlPackages.DBDmysql makeWrapper ];
  postInstall = ''
    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

}
