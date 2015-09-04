Archangel manages a directory of apps using Angel, which gets reconfigured on
SIGHUP to reflect the contents of the directory.  The directory to be managed
has to be defined through the environment variable `APPSROOT`.

Apps are directories which may contain an executable, identified by the
environment variable `APPRUNRELPATH`.  If such an executable exists, then its
expected to produce a long-running forground process.  Any other files are
ignored.

# Example
Let's assume we have a directory of apps, each one managed as Nix profile in a
similar way user profiles are managed.  Run these apps with something like:

    APPSROOT=/nix/var/nix/profiles/by-apps \
    APPRUNRELPATH=profile/run \
    archangel
