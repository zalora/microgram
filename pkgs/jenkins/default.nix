{ pkgs, lib, stdenv, fetchurl }:
let

  # some plugins have dependencies
  # use external tools to get it all
  plugins-info = import ./plugins.nix ;

  jpi = plugin: info: fetchurl {
    inherit (info) sha1;
    name = "jenkins-${plugin}-${info.version}.hpi";
    url = "https://updates.jenkins-ci.org/download/plugins/" +
          "${plugin}/${info.version}/${plugin}.hpi";
  };

  plugins = stdenv.mkDerivation {
    name = "jenkins-plugins";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
    '' + lib.concatStrings (
      lib.mapAttrsToList (name: info:
      ''
        ln -svf "${jpi name info}" "$out/${name}.hpi"
      '') plugins-info
    );
  };


in

stdenv.mkDerivation rec {
  name = "jenkins-${version}+plugins.war";
  version = "1.638";
  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1kbx9n2hj8znw0ykvgvrlf2v472f1nkdwix6a2v4rjxkgmghxmh8";
  };

  # https://wiki.jenkins-ci.org/display/JENKINS/Bundling+plugins+with+Jenkins
  build-xml = pkgs.writeText "jenkins.build.xml"
    ''
    <?xml version="1.0" encoding="UTF-8"?>
    <project basedir="." name="Jenkins-Bundle">
      <target name="bundle" description="Merge plugins into jenkins.war">
        <zip destfile="jenkins.war">
          <zipfileset src="${src}" />
          <zipfileset dir="${plugins}" prefix="WEB-INF/plugins" />
        </zip>
      </target>
    </project>
    '';

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = http://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
  };

  buildInputs = with pkgs; [ jre ];

  phases = [ "buildPhase" "installPhase" ];
  buildPhase = ''
    ln -sf ${build-xml} build.xml
    ${pkgs.ant}/bin/ant bundle
  '';
  installPhase = "cp jenkins.war $out";
}

