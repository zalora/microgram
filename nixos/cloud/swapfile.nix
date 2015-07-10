{ config, lib, pkgs, ... }:

let

  cfg = config.services.swapfile;

  inherit (lib) mkOption types;

in {

  options = {
    services.swapfile = {
      enabled = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to heuristically create a swapfile and activate it.
          The size of the swapfile is set to the minimum of the total amount
          of memory and half of the size of the disk where the swapfile is stored.
        '';
      };
      filePath = mkOption {
        type = types.str;
        description = ''
          The path to the swapfile
        '';
      };
      memoryLimit = mkOption {
        type = types.int;
        default = 12*1024;
        description = ''
          If the host has more than this many MB of RAM, no swapfile is
          activated.
        '';
      };
    };
  };

  config = {
    systemd.services.swapfile = {
      description = "EC2: setup swapfile";

      wantedBy = [ "multi-user.target" ];
      before = [ "multi-user.target" ];

      path = [ pkgs.coreutils pkgs.utillinux pkgs.gnugrep ];

      script = ''g
        memSize=$(grep MemTotal: /proc/meminfo | tr -d '[:alpha:][:space:]:')
        if (( $memSize > ${toString (cfg.memoryLimit * 1024)} )); then
          echo "Instance has enough memory, skipping swapfile"
          exit 0
        fi
        if ! [ -w "$(dirname "${cfg.filePath}")" ]; then
          echo "Can't write to swapfile's dir, skipping swapfile"
          exit 0
        fi
        if ! [ -f "${cfg.filePath}" ]; then
          diskSize=$(($(df --output=size "$(dirname "${cfg.filePath}")" | tail -n1) / 2))
          if (( $diskSize < $memSize )); then
            swapSize=$diskSize
          else
            swapSize=$memSize
          fi
          dd if=/dev/zero of="${cfg.filePath}" bs=1K count=$swapSize
          mkswap "${cfg.filePath}"
        fi
        chmod 0600 "${cfg.filePath}"
        swapon "${cfg.filePath}" || true
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
