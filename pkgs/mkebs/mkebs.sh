#!/usr/bin/env bash

set -e
set -o pipefail
set -u
set -x

# inputs:
# $toplevel is nixos top level closure
test -d "$toplevel"
# $graph should point to a file that contains exportReferencesGraph output from toplevel
test -f "$graph"

baseSnapshot=${baseSnapshot:-""}
volume=${volume:-""}
device=${device:-/dev/xvdz}


meta() {
    curl -s "http://169.254.169.254/latest/meta-data/$1"
}

export PATH=@path@
pathsFromGraph=${pathsFromGraph:-@pathsFromGraph@}

az="$(meta placement/availability-zone)"
ec2="aws --region ${az%%[abcdef]} ec2"

vwait() {
    while ! $ec2 describe-volumes --volume-ids "$volume" | grep -q available; do
        echo waiting for the volume "$volume"
        sleep 20
    done
}

if [ -n "$baseSnapshot" -a -z "$volume" ]; then
    volume=$($ec2 create-volume --availability-zone "$az" --size 40 | jq -r .VolumeId)
    vwait

    $ec2 attach-volume --volume-id "$volume" --instance-id "$(meta instance-id)" --device "$(basename $device)"
    while ! lsblk "$device"; do echo waiting for $device...; sleep 1; done

    mount "$device"1 "$mountpoint"
fi

if [ -z "$volume" ]; then
    volume=$($ec2 create-volume --availability-zone "$az" --size 40 | jq -r .VolumeId)
    vwait

    $ec2 attach-volume --volume-id "$volume" --instance-id "$(meta instance-id)" --device "$(basename $device)"
    while ! lsblk "$device"; do echo waiting for $device...; sleep 1; done

    parted -s "$device" -- mklabel msdos
    parted -s "$device" -- mkpart primary ext2 1M -1s

    mkfs.ext4 -L nixos "$device"1
fi

mountpoint=$(mktemp -d)

if ! mount | grep -q "$device.*$mountpoint"; then
    mount "$device"1 "$mountpoint"
fi

touch "$mountpoint/.ebs"
mkdir -p "$mountpoint"/{bin,etc/nixos,dev,sys,proc,nix/store}

if [ ! -f "$mountpoint"/proc/filesystems ]; then
    mount -o bind /proc "$mountpoint"/proc
fi

if [ ! -c "$mountpoint"/dev/null ]; then
    mount -o bind /dev "$mountpoint"/dev
fi

if [ ! -d "$mountpoint"/sys/kernel ]; then
    mount -o bind /sys "$mountpoint"/sys
fi

storePaths=$(perl "$pathsFromGraph" "$graph")

echo "copying everything (will take a while)..."
rsync -au $storePaths "$mountpoint/nix/store/"

# Register the paths in the Nix database.
printRegistration=1 perl "$pathsFromGraph" "$graph" | \
    chroot "$mountpoint" "$toplevel"/sw/bin/nix-store --load-db --option build-users-group ""

# Create the system profile to allow nixos-rebuild to work.
chroot "$mountpoint" "$toplevel"/sw/bin/nix-env --option build-users-group "" -p /nix/var/nix/profiles/system --set "$toplevel"

# `nixos-rebuild' requires an /etc/NIXOS.
touch "$mountpoint"/etc/NIXOS

# `switch-to-configuration' requires a /bin/sh
ln -sf "$(readlink "$toplevel"/sw/bin/sh)" "$mountpoint"/bin/sh

# Generate the GRUB menu.
LC_ALL=C NIXOS_INSTALL_GRUB=0 chroot "$mountpoint" "$toplevel"/bin/switch-to-configuration switch || true


umount "$mountpoint"/proc
umount "$mountpoint"/dev
umount "$mountpoint"/sys
umount "$mountpoint"

grub-install "$device"

if [ -n "$volume" ]; then
    $ec2 detach-volume --volume-id "$volume"

    snapshot=$($ec2 create-snapshot --volume-id "$volume" | jq -r .SnapshotId)
    # snap-72174f47
    echo now wait two years for: $snapshot

    progress=$($ec2 describe-snapshots --snapshot-ids "$snapshot" | jq -r '.Snapshots | .[] | .Progress')
    while [ "$progress" != "100%" ]; do
        echo creating snapshot: $progress
        sleep 10
        progress=$($ec2 describe-snapshots --snapshot-ids "$snapshot" | jq -r '.Snapshots | .[] | .Progress')
    done

    while ! $ec2 describe-snapshots --snapshot-ids "$snapshot" | grep completed; do
        echo waiting for state "'completed'"
        sleep 10
    done

    $ec2 register-image --architecture x86_64 --name "$toplevel-hvm" \
         --root-device-name /dev/xvda \
         --block-device-mappings \
         "[{\"DeviceName\": \"/dev/xvda\",\"Ebs\":{\"SnapshotId\":\"$snapshot\"}}]" \
         --virtualization-type hvm
fi
