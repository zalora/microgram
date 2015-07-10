{ config, pkgs, ... }:

let
  inherit (import <microgram/sdk.nix>) sdk ugpkgs;
  vmName = "Microgram";
  fileName = "platform.ova";
in
(x: { config.system.build = x; }) rec {
  vdi = config.system.build.virtualBoxImage;

  ova =
   pkgs.runCommand "virtualbox-ova" {
     buildInputs = [ config.boot.kernelPackages.virtualbox ];
     inherit vmName fileName;
   } ''
    mkdir -p $out
    echo "creating VirtualBox VM..."
    export HOME=$PWD
    VBoxManage createvm --name "$vmName" --register \
      --ostype Linux26_64

    VBoxManage modifyvm "$vmName" \
      --memory 4096 --acpi on --vram 10 \
      --nictype1 virtio --nic1 nat \
      --natpf1 "SSH,tcp,,2222,,22" \
      --natpf1 "Kibana,tcp,,9090,,9090"

    VBoxManage storagectl "$vmName" --name SATA --add sata \
      --portcount 30 --hostiocache on --bootable on
    VBoxManage storageattach "$vmName" --storagectl SATA \
      --port 0 --device 0 --type hdd \
      --medium ${vdi}/disk.vdi
    VBoxManage createhd --filename "$out/state.vdi" --size 61440
    VBoxManage storageattach "$vmName" --storagectl SATA \
      --port 1 --device 0 --type hdd \
      --medium "$out/state.vdi"

    echo "exporting VirtualBox VM..."
    VBoxManage export "$vmName" --output "$out/$fileName"
    rm -f $out/state.vdi
  '';
}
