with import <nixpkgs/lib>;
rec {
  # https://github.com/NixOS/nixpkgs/commit/5f077e229625583072ebf63ea48b11170771b0ed
  /* Return a module that causes a warning to be shown if the
     specified option is defined. For example,

       mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ]

     causes a warning if the user defines boot.loader.grub.bootDevice.
  */
  mkRemovedOptionModule = optionName:
    { options, ... }:
    { options = setAttrByPath optionName (mkOption {
        visible = false;
      });
      config.warnings =
        let opt = getAttrFromPath optionName options; in
        optional opt.isDefined
          "The option definition `${showOption optionName}' in ${showFiles opt.files} no longer has any effect; please remove it.";
    };

  /* Return a module that causes a warning to be shown if the
     specified "from" option is defined; the defined value is however
     forwarded to the "to" option. This can be used to rename options
     while providing backward compatibility. For example,

       mkRenamedOptionModule [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ]

     forwards any definitions of boot.copyKernels to
     boot.loader.grub.copyKernels while printing a warning.
  */
  mkRenamedOptionModule = from: to: doRename {
    inherit from to;
    visible = false;
    warn = true;
    use = builtins.trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'.";
  };

  /* Like ‘mkRenamedOptionModule’, but doesn't show a warning. */
  mkAliasOptionModule = from: to: doRename {
    inherit from to;
    visible = true;
    warn = false;
    use = id;
  };

  doRename = { from, to, visible, warn, use }:
    let
      toOf = attrByPath to
        (abort "Renaming error: option `${showOption to}' does not exists.");
    in
      { config, options, ... }:
      { options = setAttrByPath from (mkOption {
          description = "Alias of <option>${showOption to}</option>.";
          apply = x: use (toOf config);
        });
        config = {
        /*
          warnings =
            let opt = getAttrFromPath from options; in
            optional (warn && opt.isDefined)
              "The option `${showOption from}' defined in ${showFiles opt.files} has been renamed to `${showOption to}'.";
              */
        } // setAttrByPath to (mkAliasDefinitions (getAttrFromPath from options));
      };

}
