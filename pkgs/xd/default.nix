{ stdenv }:

stdenv.mkDerivation {
  name = "xd";

  buildCommand = ''
    install -Dm755 $script $out/bin/xd
  '';

  script = ./xd;

  meta = with stdenv.lib; {
    description = "Execute command setting the current dir to the first argument";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
