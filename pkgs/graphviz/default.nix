{ stdenv, fetchurl, pkgconfig, libpng, libjpeg
, yacc, libtool, fontconfig, pango, gd, gts
}:

# this is a stripped version of graphviz that does not support include xlibs, pango, expat and smth else

assert stdenv.system != "x86_64-darwin";

stdenv.mkDerivation rec {
  name = "graphviz-2.36.0";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "0qb30z5sxlbjni732ndad3j4x7l36vsxpxn4fmf5fn7ivvc6dz9p";
  };

  buildInputs = [ pkgconfig libpng libjpeg yacc libtool fontconfig gd gts ];

  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
     # "--with-expatincludedir=${expat}/include" # see http://thread.gmane.org/gmane.comp.video.graphviz/5041/focus=5046
     # "--with-expatlibdir=${expat}/lib"
      "--without-x"
    ];

  preBuild = ''
    sed -e 's@am__append_5 *=.*@am_append_5 =@' -i lib/gvc/Makefile
  '';

  meta = {
    homepage = "http://www.graphviz.org/";
    description = "Open source graph visualization software";

    longDescription = ''
      Graphviz is open source graph visualization software. Graph
      visualization is a way of representing structural information as
      diagrams of abstract graphs and networks. It has important
      applications in networking, bioinformatics, software engineering,
      database and web design, machine learning, and in visual
      interfaces for other technical domains.
    '';

    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
