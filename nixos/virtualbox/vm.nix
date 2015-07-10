{ config, pkgs, lib, ... }:

let
  inherit (import <microgram/sdk.nix>) sdk ugpkgs;
in {
  options = {
    ova = {
      name = lib.mkOption {
        default = "Microgram";
        type = lib.types.str;
        description = ''
          Name of the generated VM.
        '';
      };
      fileName = lib.mkOption {
        default = "microgram.ova";
        type = lib.types.str;
        description = ''
          Name of the generated VM file.
        '';
      };
    };
  };

  config.system.build = {
    vdi = config.system.build.virtualBoxImage;

    ova =
     sdk.runCommand "virtualbox-ova" {
       buildInputs = [ config.boot.kernelPackages.virtualbox ];
     } ''
      mkdir -p $out
      echo "creating VirtualBox VM..."
      export HOME=$PWD
      VBoxManage createvm --name "${config.ova.name}" --register \
        --ostype Linux26_64

      VBoxManage modifyvm "${config.ova.name}" \
        --memory 4096 --acpi on --vram 10 \
        --nictype1 virtio --nic1 nat \
        --natpf1 "SSH,tcp,,2222,,22" \
        --natpf1 "Kibana,tcp,,9090,,9090"

      VBoxManage storagectl "${config.ova.name}" --name SATA --add sata \
        --portcount 30 --hostiocache on --bootable on
      VBoxManage storageattach "${config.ova.name}" --storagectl SATA \
        --port 0 --device 0 --type hdd \
        --medium ${config.system.build.vdi}/disk.vdi
      VBoxManage createhd --filename "$out/state.vdi" --size 61440
      VBoxManage storageattach "${config.ova.name}" --storagectl SATA \
        --port 1 --device 0 --type hdd \
        --medium "$out/state.vdi"

      echo "exporting VirtualBox VM..."
      VBoxManage export "${config.ova.name}" --output "$out/${config.ova.fileName}"
      rm -f $out/state.vdi
    '';
  };
}
