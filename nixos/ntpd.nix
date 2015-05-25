{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) ntp;

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  configFile = pkgs.writeText "ntp.conf" ''
    driftfile ${stateDir}/ntp.drift

    restrict 127.0.0.1
    restrict -6 ::1

    ${toString (map (server: "server " + server + " iburst\n") config.services.ntp.servers)}
  '';

  ntpFlags = lib.concatStringsSep " " ([
    "-c ${configFile}"
    "-u ${ntpUser}:nogroup"
  ] ++ map (interface:
    "-I ${interface}"
  ) config.services.ntp.interfaces);
in
{ options = {
    services.ntp = {
      enable = mkOption {
        default = !config.boot.isContainer;
        description = ''
          Whether to synchronise your machine's time using the NTP
          protocol.
        '';
      };

      servers = mkOption {
        default = [
          "0.nixos.pool.ntp.org"
          "1.nixos.pool.ntp.org"
          "2.nixos.pool.ntp.org"
          "3.nixos.pool.ntp.org"
        ];
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

      interfaces = mkOption {
        default = [];
        description = ''
          The name or address of interfaces to listen on.
          If this list is empty, we listen on every address.
        '';
      };
    };
  };
  config = mkIf config.services.ntp.enable {
    environment.systemPackages = [ pkgs.ntp ];
    users.extraUsers = singleton
      { name = ntpUser;
        uid = config.ids.uids.ntp;
        description = "NTP daemon user";
        home = stateDir;
      };
    systemd.services.ntpd =
      { description = "NTP Daemon";
        wantedBy = [ "multi-user.target" ];
        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${ntpUser} ${stateDir}
          '';
        serviceConfig = {
          ExecStart = "@${ntp}/bin/ntpd ntpd -g ${ntpFlags}";
          Type = "forking";
        };
      };
  };
}
