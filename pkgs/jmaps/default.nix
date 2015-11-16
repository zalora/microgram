{ stdenv, openjdk, fetchurl, perf-map-agent, runCommand }: let
  jmaps = fetchurl {
    url = https://raw.githubusercontent.com/brendangregg/Misc/fc2856eb0d0d7fe7a3b3dfef8f873603f6a4a3eb/java/jmaps;
    sha256 = "15bihx36qdjv25l1xdnkg3lrlmkjy9cmj6gsk4dybr141xfg9x4i";
  };
in runCommand "jmaps" {} ''
  mkdir -p $out/bin
  cp ${jmaps} $out/bin/jmaps
  sed -i 's,/usr/lib/jvm/java-8-oracle,${openjdk}/lib/openjdk,' $out/bin/jmaps
  sed -i 's,/usr/lib/jvm/perf-map-agent,${perf-map-agent},' $out/bin/jmaps
  sed -i 's,su - $user -c,sudo -u $user sh -c,' $out/bin/jmaps
  chmod +x $out/bin/jmaps
''
