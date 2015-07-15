let
  diagnostics = {
    google.http-ok = "http://google.com";
    true0.script-retcode = ''
      true
    '';
    metric.script-metric = ''
      echo 42
    '';
  };
in
(import ./. { inherit diagnostics; }).config.paths.wtf
