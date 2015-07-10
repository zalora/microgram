let
  nixos = modules:
    let
      hvm-config = { config, ... }: {
        imports = [ <microgram/nixos/ec2> ] ++ modules;
        ec2.hvm = true; # pv is almost past :)
      };
    in (import <microgram/nixos> { configuration = hvm-config; });
in
{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; config.allowUnfree = true; }
, ugpkgs ? import <microgram/pkgs> { inherit pkgs; }
, modules ? []
, config ? (nixos modules).config
, aws-env ? {}
, ... }:

let
  inherit (import <nixpkgs/lib>) listToAttrs nameValuePair optionalString;

  ec2-bundle-image = "${pkgs.ec2_ami_tools}/bin/ec2-bundle-image";
  ec2-upload-bundle = "${pkgs.ec2_ami_tools}/bin/ec2-upload-bundle";
  awscli = "${pkgs.awscli}/bin/aws";
  jq = "${pkgs.jq}/bin/jq";

  ami = config.system.build.amazonImage;
  ami-name = "$(basename ${ami})-nixos-platform";
in
rec {
  inherit ami;

  upload = pkgs.runCommand "ami-ec2-upload-image" env ''
    export PATH=${pkgs.curl}/bin:$PATH
    export CURL_CA_BUNDLE=${pkgs.cacert}/etc/ca-bundle.crt

    ${ec2-upload-bundle} \
      -b "${upload-context.bucket}/${ami-name}" \
      -d ${bundle} -m ${bundle}/nixos.img.manifest.xml \
      -a "$AWS_ACCESS_KEY" -s "$AWS_SECRET_KEY" --region ${upload-context.region}

    echo "${upload-context.bucket}/${ami-name}/nixos.img.manifest.xml" > $out
  '';
}
