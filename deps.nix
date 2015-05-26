#
# Nix expression-based dependency manager for Git that performs caching.
#
# Dependencies: nix, jq and bash.
#
# Usage:
#
# nix-instantiate --eval --strict --json -A get-deps deps.nix | jq -r '.[]' | bash -e
#
let
  inherit (builtins) getEnv attrNames;
in rec {
  # must not use anything but builtins to bootstrap
  mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (attrNames attrs);

  defscope = {
    platform = ./.;
  };

  deps = {
    nixpkgs = {
      url = "git://github.com/NixOS/nixpkgs.git";
      rev = "79effb88a0d342ffc423b7044548c34c7f5c1aa4"; # branch: release-14.12
    };
  };

  # $CHECKOUT_DEST must be exported and point to an absolute path.
  # $ERIS_CACHE may override the default location of git caches.
  # $ERIS_NOFETCH may be set to a non-empty value to prevent fetching.
  prefetch-script =
    { name, url, rev ? null, branch ? null, force-fetch ? false }:
    let
      # `cache-dir' points to a (possibly non-existent) directory where a shared
      # cache of the repository should be maintained.  The shared cache is used
      # to create multiple working trees of the repository.
      cache-dir = "\${ERIS_CACHE:-$CHECKOUT_DEST/_cache}/${name}.git";
      cache-git = "git --git-dir=${cache-dir}";

      # work-tree points to a (maybe non-existent) directory, where the
      # specified revision of the respository should be checked out.
      # Please note, that work-git is using -C because git submodule doesn't
      # work with --git-dir and --work-tree.
      work-tree = "$CHECKOUT_DEST/${name}";
      work-git = "git -C ${work-tree}";

      effective-rev =
        let rev-from-env = getEnv "deps.${name}"; in
        if rev-from-env != "" then rev-from-env
        else if rev != null then rev
        else "$(${cache-git} rev-parse ${name}/${branch})";

      up-to-date =
        if force-fetch then ''
            echo bypassing version check >&2
            false
        '' else ''
          [ -d ${cache-dir} ] &&
          [ -d ${work-tree} ] &&
          [ "$(${work-git} rev-parse HEAD)" == "${effective-rev}" ] &&
          echo ${name} is already at rev ${effective-rev} >&2
        '';
    in ''
      if ! { ${up-to-date} }; then
        if [ ! -d ${cache-dir} ]; then
          mkdir -p ${cache-dir}
          ${cache-git} init --bare
        fi
        if ! url=$(${cache-git} config remote.${name}.url); then
          ${cache-git} remote add ${name} ${url}
        elif [ $url != ${url} ]; then
          ${cache-git} remote set-url ${name} ${url}
        fi
        [ -z "$ERIS_NOFETCH" ] && ${cache-git} fetch ${name}
        if [ ! -d ${work-tree} ]; then
          git clone -n --shared ${cache-dir} ${work-tree}
        fi
        ${work-git} checkout "${effective-rev}" -- ${work-tree}
        ${work-git} checkout "${effective-rev}"
        ${work-git} submodule init
        ${work-git} submodule update
      fi
      ${work-git} clean -dxf
    '';

  get-deps =
    let
      # Configure `ln' to replace the target, even if it's a (symlink to)
      # directory.  This is non-standard, so everyone does it differently.
      ln-rm-target =
        if builtins.currentSystem == "x86_64-darwin"
          then "ln -Fh"
          else "ln -T"; # everything else is assumed to run GNU coreutils

      symlink-dep = name: path:
        "${ln-rm-target} -fs ${toString path} $CHECKOUT_DEST/${name}";
    in [''
      export CHECKOUT_DEST=$PWD/deps
      mkdir -p $CHECKOUT_DEST
    ''] ++ (mapAttrsToList symlink-dep defscope)
        ++ (mapAttrsToList (name: dep: prefetch-script (dep // { inherit name; })) deps);
}
