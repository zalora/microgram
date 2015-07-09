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
    mkdir -p $out/bin
    substituteAll $script $out/bin/${name}
    chmod +x $out/bin/${name}
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
