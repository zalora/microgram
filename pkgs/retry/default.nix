{ stdenv }:

stdenv.mkDerivation {
  name = "retry";

  buildCommand = ''
    install -Dm755 $script $out/bin/retry
  '';
    
  script = ./retry;

  meta = with stdenv.lib; {
    description = "Retry failed commands";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
