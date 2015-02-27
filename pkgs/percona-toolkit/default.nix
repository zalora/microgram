{ perlPackages, fetchurl }:

perlPackages.buildPerlPackage rec {
  name = "percona-toolkit-2.2.13";

  src = fetchurl {
    url = http://www.percona.com/redir/downloads/percona-toolkit/2.2.13/tarball/percona-toolkit-2.2.13.tar.gz;
    sha256 = "0qsazzpb2za6fc552nbmdkq0hv8gvx2g275x4bx7mkb3s4czcscf";
  };

  preConfigure = ''
    find . | while read fn; do
        if test -f "$fn"; then
            first=$(dd if="$fn" count=2 bs=1 2> /dev/null)
            if test "$first" = "#!"; then
                sed < "$fn" > "$fn".tmp \
                    -e "s|^#\!\(.*[/\ ]perl.*\)$|#\!$perl/bin/perl $perlFlags|"
                if test -x "$fn"; then chmod +x "$fn".tmp; fi
                mv "$fn".tmp "$fn"
            fi
        fi
    done
  '';

  doCheck = false;

  propagatedBuildInputs = [ perlPackages.DBI perlPackages.DBDmysql ];
}
