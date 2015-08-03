{ config
, lib
, aws-env ? {}
, upload-context ? rec {
    region = "eu-west-1";
    bucket = "platform-${region}";
  }
,  ... }:
let
  inherit (import <microgram/sdk.nix>) pkgs;

  inherit (lib) foldAttrs listToAttrs nameValuePair optionalString;

  ec2-bundle-image = "${pkgs.ec2_ami_tools}/bin/ec2-bundle-image";
  ec2-upload-bundle = "${pkgs.ec2_ami_tools}/bin/ec2-upload-bundle";
  awscli = "${pkgs.awscli}/bin/aws";
  jq = "${pkgs.jq}/bin/jq";

  env =
    let
      getEnvs = xs: listToAttrs (map (x: nameValuePair x (builtins.getEnv x)) xs);

      base1 = getEnvs [ "AWS_ACCOUNT_ID" "AWS_X509_CERT" "AWS_X509_KEY" ];
      base2 = getEnvs [ "AWS_ACCESS_KEY" "AWS_SECRET_KEY" ];
      more = {
        AWS_ACCESS_KEY_ID = env.AWS_ACCESS_KEY;
        AWS_SECRET_ACCESS_KEY = env.AWS_SECRET_KEY;
      };
    in base1 // base2 // more // aws-env // { __noChroot = true; };

  ami = config.system.build.amazonImage;
  ami-name = "$(basename ${ami})-nixos-platform";
in
(as: { config.system.build = as; }) rec {
  # 1. bundle (chop the system image into parts & sign)
  s3Bundle = pkgs.runCommand "ami-ec2-bundle-image" env ''
    mkdir -p $out

    ${ec2-bundle-image} \
      -c "$AWS_X509_CERT" -k "$AWS_X509_KEY" -u "$AWS_ACCOUNT_ID" \
      -i "${ami}/nixos.img" --arch x86_64 -d $out
  '';

  # 2. upload (copy chopped parts & manifest to S3)
  s3Upload = pkgs.runCommand "ami-ec2-upload-image" env ''
    export PATH=${pkgs.curl}/bin:$PATH
    export CURL_CA_BUNDLE=${pkgs.cacert}/etc/ca-bundle.crt

    ${ec2-upload-bundle} \
      -b "${upload-context.bucket}/${ami-name}" \
      -d ${s3Bundle} -m ${s3Bundle}/nixos.img.manifest.xml \
      -a "$AWS_ACCESS_KEY" -s "$AWS_SECRET_KEY" --region ${upload-context.region}

    echo "${upload-context.bucket}/${ami-name}/nixos.img.manifest.xml" > $out
  '';

  # 3. register (register the manifest with ec2), get AMI id
  s3Register = pkgs.runCommand "ami-ec2-register-image" env ''
    set -o pipefail

    ${awscli} ec2 register-image \
      --region "${upload-context.region}" \
      --name "${ami-name}" \
      --description "${ami-name}" \
      --image-location "$(cat ${s3Upload})" \
      --virtualization-type "hvm" | ${jq} -r .ImageId > $out || rm -f $out
    cat $out
  '';
}
