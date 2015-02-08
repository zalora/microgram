{
  # common source directory filter used when building packages from git repos
  git-repo-filter =
    let f =
      path: type:
        let base = baseNameOf path;
        in type != "unknown" && base != ".git" && base != "result";
    in builtins.filterSource f;
}
