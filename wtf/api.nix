{ config, options, lib, name, ... }:
let
  inherit (lib) types mkOption replaceChars;

  memcached-tuple =
    types.nullOr (types.submodule ({ ... }: {
        options = {
          key = mkOption { type = types.str; default = "hello"; };
          target = mkOption { type = types.str; default = "localhost:11211"; };
        };
    }));
in
{
  imports = [
    ./shell.nix
  ];

  options = {
    name = mkOption { default = name; };

    description = mkOption {
      type = types.str;
      default = "";
      description = "Check description.";
    };

    tags = mkOption {
      type = with types; listOf str;
      default = [];
      description = "";
    };

    timeseries = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Activate implementation-defined timeseries polling for this check.";
      };

      period = mkOption {
        type = types.str;
        default = "1m";
        description = "Check period, on a format accepted by sleep.";
      };

      unit = mkOption {
        type = types.enum [
          "Seconds" "Microseconds" "Milliseconds" "Bytes"
          "Kilobytes" "Megabytes" "Gigabytes" "Terabytes"
          "Bits" "Kilobits" "Megabits" "Gigabits" "Terabits"
          "Percent" "Count" "Bytes/Second" "Kilobytes/Second"
          "Megabytes/Second" "Gigabytes/Second" "Terabytes/Second"
          "Bits/Second" "Kilobits/Second" "Megabits/Second" "Gigabits/Second"
          "Terabits/Second" "Count/Second" "None"
        ];
        default = "None";
        description = ''
          Metric unit.
          Currently limited to choices from
          http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDatum.html
        '';
      };

      descriptive-unit = mkOption {
        type = types.nullOr types.str;
        default = if config.timeseries.unit == "None" then null else config.timeseries.unit;
        description = ''
          A description of the metric's unit, suitable for interpolation into
          the output of 'wtf'.
        '';
      };
    };

    alarm = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };
          statistic = mkOption {
            type = types.enum [
              "SampleCount" "Average" "Sum" "Minimum" "Maximum"
            ];
            default = "Sum";
            description = ''
              The statistic to apply to the check's metric when evaluating whether
              to trigger an alarm.  Choose from {SampleCount, Average, Sum, Minimum,
              Maximum}, defaults to "Sum".
            '';
          };
          evaluation-periods = mkOption {
            type = types.int;
            default = 1;
            description = ''
              The number of periods over which data is compared to the threshold,
              see 'comparison-operator'.
            '';
          };
          threshold = mkOption {
            type = types.str;
            default = "0";
            description = ''
              The value against which the specified statistic is compared, see
              'comparison-operator'.  For implementation reasons (Nix cannot type
              double-precision floating points), this is a double formatted as a
              string.
            '';
          };
          comparison-operator = mkOption {
            type = types.enum [
              "GreaterThanOrEqualToThreshold" "GreaterThanThreshold"
              "LessThanThreshold" "LessThanOrEqualToThreshold"
            ];
            default = "GreaterThanOrEqualToThreshold";
            description = ''
              The arithmetic operation to use when comparing the statistic
              and threshold over its evaluation period, determines whether
              the alarm is triggered.
              Choose from {GreaterThanOrEqualToThreshold, GreaterThanThreshold,
              LessThanThreshold, LessThanOrEqualToThreshold}, defaults to
              "GreaterThanOrEqualToThreshold".
            '';
          };
          action = mkOption {
            type = types.str;
            description = ''
              The action perform if the alarm is triggered, specified as an ARN.
            '';
          };
        };
      }));
    };

    timeout = mkOption {
      type = types.str;
      default = "10s";
      description = "Check timeout, on a format accepted by sleep.";
    };

    script-retcode = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = "Bash script that returns non-zero exitcode on failure. Do not use exec in a script.";
    };

    script-metric = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = "Bash script that outputs the numeric metric value to stdout. Do not use exec in a script.";
    };

    http-ok = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "HTTP URL that is supposed to return a 2xx or a 3xx response.";
    };

    mysql-metric = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "MySQL query that returns one row with a single column which is a numeric value.";
    };

    mysql-status = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "MySQL variable from SHOW STATUS that returns a numeric value.";
    };

    memcached-stat = mkOption {
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          key = mkOption { type = types.str; default = "total_connections"; };
          target = mkOption { type = types.str; default = "localhost:11211"; };
        };
      }));
      default = null;
      description = "Memcached numeric statistic.";
    };

    memcached-kvmetric = mkOption {
      type = memcached-tuple;
      default = null;
      description = "Memcached key lookup that returns a numeric value.";
    };

    memcached-kvmetric-exists = mkOption {
      type = memcached-tuple;
      default = null;
      description = "Memcached key lookup that returns a positive status code when a key is there.";
    };
  };
}
