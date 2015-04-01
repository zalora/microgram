{ config, lib, pkgs, ... }:
let
  inherit (lib) concatStringsSep mapAttrsToList mkOverride mkOption types optionalString;

  plat-pkgs = import <platform/pkgs> { inherit pkgs; };
  retry = "${plat-pkgs.retry}/bin/retry";
  base64 = "${pkgs.coreutils}/bin/base64";
  jq = "/usr/bin/env LD_LIBRARY_PATH=${pkgs.jq}/lib ${pkgs.jq}/bin/jq";
  curl = "${pkgs.curl}/bin/curl -s --retry 3 --retry-delay 0 --fail";
  curl-nofail = "${pkgs.curl}/bin/curl -s --retry 3 --retry-delay 0";
  wget = "${pkgs.wget}/bin/wget -q --retry-connrefused -O -";
  awk = "${pkgs.gawk}/bin/awk";
  openssl = "${pkgs.openssl}/bin/openssl";
  hostname = "${pkgs.nettools}/bin/hostname";
  ip = "${pkgs.iproute}/sbin/ip";
  bash = "${pkgs.bash}/bin/bash";
  xargs = "${pkgs.findutils}/bin/xargs";

  register-hostname = {
    zoneId, zone, iamCredentialName,
    useLocalHostname,
    query ? if useLocalHostname then "local-ipv4" else "public-hostname",
    recordType ? if useLocalHostname then "A" else "CNAME"
  }: pkgs.writeScript "ec2-register-hostname" ''
    date=$(${curl} -I https://route53.amazonaws.com/date | ${awk} '/^Date: / {sub("Date: ", "", $0); sub("\\r", "", $0); print $0}')

    iam="${iamCredentialName}"
    if [ -z "$iam" ]; then
      # autodetect
      set -- $(${curl} http://169.254.169.254/latest/meta-data/iam/security-credentials/ 2>/dev/null | head -1)
      iam="$1"
      if [ -z "$iam" ]; then
        exit 1
      fi
    fi

    set -- $(${wget} http://169.254.169.254/latest/meta-data/iam/security-credentials/${iamCredentialName} \
              | ${jq} -r '.SecretAccessKey, .AccessKeyId, .Token')

    signature=$(echo -n $date | ${openssl} dgst -binary -sha1 -hmac $1 | ${base64})
    auth_header="X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=$2,Algorithm=HmacSHA1,Signature=$signature"
    hostname=$(${hostname}).${zone}
    record_value=$(${wget} http://169.254.169.254/latest/meta-data/${query})

    ${retry} ${curl-nofail} -d @/dev/stdin \
          -H "Content-Type: text/xml" \
          -H "x-amz-date: $date" \
          -H "$auth_header" \
          -H "x-amz-security-token: $3" \
          -X POST https://route53.amazonaws.com/2013-04-01/hostedzone/${zoneId}/rrset <<__EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <ChangeResourceRecordSetsRequest xmlns="https://route53.amazonaws.com/doc/2013-04-01/">
    <ChangeBatch>
       <Changes>
          <Change>
             <Action>UPSERT</Action>
             <ResourceRecordSet>
                <Name>$hostname</Name>
                <Type>${recordType}</Type>
                <TTL>30</TTL>
                <ResourceRecords>
                   <ResourceRecord><Value>$record_value</Value></ResourceRecord>
                </ResourceRecords>
             </ResourceRecordSet>
          </Change>
       </Changes>
    </ChangeBatch>
    </ChangeResourceRecordSetsRequest>
    __EOF
    
    curl_error=$?

    echo
    exit $curl_error
 '';

  ec2-autohostname = ''
    ${ip} route delete blackhole 169.254.169.254 2>/dev/null || true

    # applying the hostname from UserData if any:
    set -- $(${curl} http://169.254.169.254/latest/user-data | ${jq} -r .hostname)
    if [ -z $1 ]; then
      echo "current hostname: $(${hostname})"
    else
      echo "setting hostname from EC2 user-data: '$1'"
      ${hostname} $1
    fi

    # registering route 53 hostnames if any:
    echo ${concatStringsSep " " (
        mapAttrsToList (_: args: register-hostname {
         zone = args.name;
         inherit (args) zoneId iamCredentialName useLocalHostname;
       }) config.ec2.route53RegisterHostname)} | ${xargs} -n1 -P2 ${bash}

    ${optionalString (!config.ec2.metadata) ''
    ip route add blackhole 169.254.169.254/32
    ''}
  '';
in
{
  options = {
    ec2.route53RegisterHostname = mkOption {
      type = types.attrsOf (types.submodule ({ lib, name, ... }: with lib; {
        options = {
          name = mkOption {
            type = types.string;
            default = name;
            description = ''
              Route53 Hosted Domain Name (can be a sub-domain of a more high-level domain name).
            '';
          };

          zoneId = mkOption {
            type = types.string;
            example = "ZOZONEZONEZONE";
            description = ''
              Route53 Hosted Zone ID for the domain specified in name;
            '';
          };

          iamCredentialName = mkOption {
            type = types.string;
            example = "doge-iam-dns-profile";
            default = "";
            description = ''
              Instance IAM Role name. Leave empty to autodetect.
            '';
          };

          useLocalHostname = mkOption {
            type = types.bool;
            default = false;
            description = ''
              CNAMEs to the internal hostname. Useful when doing VPC tunneling.
            '';
          }; 
        };
      }));

      default = {};
    };
  };

  config = {
    system.activationScripts = {
      inherit ec2-autohostname;
    };

    systemd.services.ec2-autohostname = {
      description = "EC2: apply dynamic hostname";

      wantedBy = [ "multi-user.target" "sshd.service" ];
      before = [ "sshd.service" ];
      after = [ "fetch-ec2-data.service" ];

      script = ec2-autohostname;

      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
    };
  };
}
