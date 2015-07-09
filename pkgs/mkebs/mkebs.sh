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
aminame=${toplevel}-hvm

meta() {
    curl -s "http://169.254.169.254/latest/meta-data/$1"
}

# global in: $aminame
amitest() {
    set -- $(aws --region ap-southeast-1 ec2 describe-images --filters Name=name,Values=/nix/store/nl1kx7wjihx8k6cvg5n3zkdmp2l65mh7-nixos-14.12pre-git-hvm | jq -r '.Images | .[] | [.Name, .ImageId] | .[]')

    if [ "$1" = "$aminame" ]; then
        echo AMI already exists: $2 >&2
        exit 11
    fi
}

export PATH=@path@
pathsFromGraph=${pathsFromGraph:-@pathsFromGraph@}

az="$(meta placement/availability-zone)"
ec2="aws --region ${az%%[abcdef]} ec2"

# global in: $volume
vwait() {
    while ! $ec2 describe-volumes --volume-ids "$volume" | grep -q available; do
        echo waiting for the volume "$volume"
        sleep 20
    done
}

# global in: $volume
# global out: $device
attach() {
    local attached
    attached=0
    for i in {d..z}; do
        device=/dev/xvd${i}
        if $ec2 attach-volume --volume-id "$volume" --instance-id "$(meta instance-id)" --device "$(basename $device)"; then
            attached=1
            # danger: successful attachment may hang forever when reattaching new volumes sometimes
            while ! lsblk "$device"; do echo waiting for $device...; sleep 1; done
            break
        fi
    done

    if [ "$attached" -eq 0 ]; then
        echo could not attach the ebs volume anywhere, leaking "$volume" 2>&1
        exit 11
    fi
}

amitest

if [ -n "$baseSnapshot" ]; then
    # starting from a base snapshot
    volume=$($ec2 create-volume --availability-zone "$az" --size 40 --snapshot-id "$baseSnapshot" | jq -r .VolumeId)
    vwait
    attach
else
    # starting from scratch
    volume=$($ec2 create-volume --availability-zone "$az" --size 40 | jq -r .VolumeId)
    vwait
    attach

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
rsync -auv $storePaths "$mountpoint/nix/store/"

# Register the paths in the Nix database.
printRegistration=1 perl "$pathsFromGraph" "$graph" | \
    chroot "$mountpoint" "$toplevel"/sw/bin/nix-store --load-db --option build-users-group ""

# Create the system profile to allow nixos-rebuild to work.
chroot "$mountpoint" "$toplevel"/sw/bin/nix-env --option build-users-group "" -p /nix/var/nix/profiles/system --set "$toplevel"

# `nixos-rebuild' requires an /etc/NIXOS.
touch "$mountpoint"/etc/NIXOS

# `switch-to-configuration' requires a /bin/sh
ln -sf "$(readlink "$toplevel"/sw/bin/sh)" "$mountpoint"/bin/sh

# XXX: we don't really need to generate any menus as there are no rollbacks
# Generate the GRUB menu.
LC_ALL=C NIXOS_INSTALL_GRUB=0 chroot "$mountpoint" "$toplevel"/bin/switch-to-configuration switch || true


umount "$mountpoint"/proc
umount "$mountpoint"/dev
umount "$mountpoint"/sys
umount "$mountpoint"

if [ -n "$baseSnapshot" ]; then
    grub-install "$device"
fi

if [ -n "$volume" ]; then
    $ec2 detach-volume --volume-id "$volume"

    date
    snapshot=$($ec2 create-snapshot --volume-id "$volume" | jq -r .SnapshotId)
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
    date

    $ec2 register-image --architecture x86_64 --name "$aminame" \
         --root-device-name /dev/xvda \
         --block-device-mappings \
         "[{\"DeviceName\": \"/dev/xvda\",\"Ebs\":{\"SnapshotId\":\"$snapshot\"}}]" \
         --virtualization-type hvm
fi
