{ pkgs, newrelic-python, statsd, tornado }:
let
  inherit (pkgs) pythonPackages fetchurl lib;
in rec {
  thumbor = import ./thumbor-newrelic.nix { inherit lib thumbor-base newrelic-python; };

  thumbor-base = pythonPackages.buildPythonPackage rec {
    name = "thumbor-4.8.2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/thumbor/${name}.tar.gz";
      md5 = "373588081b1c24dd7037c3a8b8f8086b";
    };

    doCheck = false;

    propagatedBuildInputs =
      (with pythonPackages; [
        pycrypto
        pycurl
        pillow
        derpconf
        python_magic
        thumborPexif
        (pkgs.opencv.override {
            gtk = null;
            glib = null;
            xineLib = null;
            gstreamer = null;
            ffmpeg = null;
        })
      ]) ++ [
        tornado
        statsd
      ];

    meta = {
      description = "Thumbor is a smart imaging service. It enables on-demand crop, resizing and flipping of images.";
      homepage = https://github.com/thumbor/thumbor/wiki;
      license = lib.licenses.mit;
    };
  };
}
