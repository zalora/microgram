{ stdenv, coreutils, perl, parted, nix, bash, utillinux, pathsFromGraph,
   grub2, rsync, gnugrep, gnused, curl, awscli, jq, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "mkebs";

  path = stdenv.lib.makeSearchPath "bin" [
    coreutils perl parted nix bash utillinux rsync
    grub2 gnugrep gnused curl awscli jq e2fsprogs
  ];
  inherit pathsFromGraph;

  script = ./mkebs.sh;

  buildCommand = ''
    substituteAll $script $out
    chmod +x $out
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
