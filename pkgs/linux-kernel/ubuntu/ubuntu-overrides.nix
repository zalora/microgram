{ runCommand, findutils, gawk, bash, stdenv, kernel }:
let
  args = {
    buildInputs = [ findutils gawk bash ];
    inherit (kernel) version patches src dev modDirVersion configfile;
    features = "";
    __noChroot = true;
  };
  mod = "lib/modules/${kernel.modDirVersion}";
in
runCommand "microgram-linux-${kernel.version}" args (''
  mkdir -p $out

  cp -v ${kernel}/{bzImage,System.map} $out
  mkdir -p $out/${mod}
  cp -v ${kernel}/${mod}/modules.* $out/${mod}/

  # include modules selected by ubuntu guys
  bash ${./module-inclusion} {${kernel},$out}/${mod}/kernel ${./generic.inclusion-list}
'')
