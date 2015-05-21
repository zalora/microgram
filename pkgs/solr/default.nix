{ stdenv, fetchurl, zip }:

let

  deps = {
    logback-classic = fetchurl {
      url = "http://repo1.maven.org/maven2/ch/qos/logback/logback-classic/1.1.3/logback-classic-1.1.3.jar";
      sha256 = "1map874h9mrv2iq8zn674sb686fdcr2p5k17ygajqr0dbn7z3hwq";
    };
    logback-core = fetchurl {
      url = "http://repo1.maven.org/maven2/ch/qos/logback/logback-core/1.1.3/logback-core-1.1.3.jar";
      sha256 = "052w3z1sp7m2ssrd8c644wxi8xia9crcrjmcixdk3lwm54sgvh27";
    };
    logback-access = fetchurl {
      url = "http://repo1.maven.org/maven2/ch/qos/logback/logback-access/1.1.3/logback-access-1.1.3.jar";
      sha256 = "169hk1zr0z4cwgksf1yaq6s4v5lnjfws5s7gqyzln5l2z8lf00yw";
    };
    netty = fetchurl {
      url = "http://repo.maven.apache.org/maven2/io/netty/netty/3.6.1.Final/netty-3.6.1.Final.jar";
      sha256 = "1fd7ihi4fsclgnwjy1m7m1hsq4r8x3zbc6lggl4psyd81k225s0d";
    };
  };

in stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "3.6.2";

  src = fetchurl {
    url = "http://archive.apache.org/dist/lucene/solr/${version}/apache-${name}.tgz";
    sha256 = "1iks7spywyfbipm5w961950cp1xgpjv4hszibgfq5p6hppf2cx2k";
  };

  buildInputs = [ zip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    zip -vd example/webapps/solr.war \
      WEB-INF/lib/slf4j-jdk14-1.6.1.jar
    mkdir -p WEB-INF/lib
    ${stdenv.lib.concatStringsSep "\n" (stdenv.lib.mapAttrsToList (d: p: ''cp -v "${p}" "WEB-INF/lib/${d}.jar"'') deps)}
    zip -vru example/webapps/solr.war WEB-INF
    ensureDir $out
    mv contrib $out/
    ensureDir $out/jetty
    mv example/start.jar example/lib example/webapps example/etc $out/jetty/
  '';

  meta = with stdenv.lib; {
    homepage = "https://lucene.apache.org/solr/";
    description = ''
      Open source enterprise search platform from the Apache Lucene project
    '';
    license = licenses.asl20;
    platforms = platforms.all;
  };

}

