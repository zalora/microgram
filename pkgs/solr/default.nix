{ stdenv, fetchurl, zip }:

let

  deps = {
    logback-classic = fetchurl {
      url = "http://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.0.13/logback-classic-1.0.13.jar";
      sha256 = "13s1qxv4jyf4hfiww8125p6iy6xyx3y37slzqhm44lqnm4697h8j";
    };
    logback-core = fetchurl {
      url = "http://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.0.13/logback-core-1.0.13.jar";
      sha256 = "1f7kjvslamql9danfyzlr0qwn8778crzym7ik172hh99kd7z5n7c";
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

