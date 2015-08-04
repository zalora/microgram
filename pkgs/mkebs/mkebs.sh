#!/usr/bin/env bash

set -e
set -o pipefail
set -u

# inputs:
# $toplevel is nixos top level closure
test -d "$toplevel"
# $graph should point to a file that contains exportReferencesGraph output from toplevel
test -f "$graph"

BASE_RESOURCE=${BASE_RESOURCE:-""}
volume=${volume:-""}
suffix=${suffix:-""}
aminame=${toplevel}-hvm${suffix}
volume_args="--volume-type gp2 --size 40"

meta() {
    curl -s "http://169.254.169.254/latest/meta-data/$1"
}

# global in: $aminame
amitest() {
    set -- $(aws --region ap-southeast-1 ec2 describe-images --filters "Name=name,Values=$aminame" | jq -r '.Images | .[] | [.Name, .ImageId] | .[]')

    if [ "${1:-}" = "$aminame" ]; then
        echo AMI already exists >&2
        echo "$2" # stdout
        exit 42
    fi
}

export PATH=@path@
pathsFromGraph=${pathsFromGraph:-@pathsFromGraph@}

az="$(meta placement/availability-zone)"
ec2="aws --region ${az%%[abcdef]} ec2"

# global in: $volume
vwait() {
    while ! $ec2 describe-volumes --volume-ids "$volume" | grep -q available; do
        echo waiting for the volume "$volume" >&2
        sleep 20
    done
    $ec2 create-tags --resources "$volume" --tags Key=ug-mkebs,Value="$toplevel" Key=Name,Value=mkebs-scratch >&2
}

# global in: $volume
# global out: $device
attach() {
    local attached
    attached=0
    for i in {d..z}; do
        device=/dev/xvd${i}
        if $ec2 attach-volume --volume-id "$volume" --instance-id "$(meta instance-id)" --device "$(basename $device)" >&2; then
            attached=1
            # danger: successful attachment may hang forever when reattaching new volumes sometimes
            while ! lsblk "$device" >&2; do echo waiting for $device... >&2; sleep 1; done
            break
        fi
    done

    if [ "$attached" -eq 0 ]; then
        echo could not attach the ebs volume anywhere, leaking "$volume" >&2
        exit 11
    fi
}

amitest

if [ -n "$BASE_RESOURCE" ]; then
    case ${BASE_RESOURCE%-*} in
        vol)
            volume=$BASE_RESOURCE
            ;;
        snap) # starting from a base snapshot
            volume=$($ec2 create-volume --availability-zone "$az" $volume_args --snapshot-id "$BASE_RESOURCE" | jq -r .VolumeId)
            ;;
        *)
            echo "unkown base resource: $BASE_RESOURCE" >&2
            exit 12
            ;;
    esac
    vwait
    attach
else
    echo 'WARNING: starting from scratch. This is slow, consider setting $BASE_RESOURCE' >&2
    echo '$BASE_RESOURCE can look like snap-xxxxxx or vol-xxxxxx' >&2
    volume=$($ec2 create-volume --availability-zone "$az" $volume_args | jq -r .VolumeId)
    vwait
    attach

    parted -s "$device" -- mklabel msdos >&2
    parted -s "$device" -- mkpart primary ext2 1M -1s >&2

    mkfs.ext4 -L nixos "$device"1 >&2
fi

while ! lsblk "$device"1 >&2; do echo waiting for $device... >&2; sleep 1; done

mountpoint=${mountpoint:-$(mktemp -d)}

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

echo "rsyncing graph for $toplevel (will take a while)..." >&2
rsync --stats -au $storePaths "$mountpoint/nix/store/" >&2

# Register the paths in the Nix database.
printRegistration=1 perl "$pathsFromGraph" "$graph" | \
    chroot "$mountpoint" "$toplevel"/sw/bin/nix-store --load-db --option build-users-group "" >&2

# Create the system profile to allow nixos-rebuild to work.
chroot "$mountpoint" "$toplevel"/sw/bin/nix-env --option build-users-group "" -p /nix/var/nix/profiles/system --set "$toplevel" >&2

# `nixos-rebuild' requires an /etc/NIXOS.
touch "$mountpoint"/etc/NIXOS

# `switch-to-configuration' requires a /bin/sh
ln -sf "$(readlink "$toplevel"/sw/bin/sh)" "$mountpoint"/bin/sh

# XXX: we don't really need to generate any menus as there are no rollbacks
# Generate the GRUB menu.
LC_ALL=C NIXOS_INSTALL_GRUB=0 chroot "$mountpoint" "$toplevel"/bin/switch-to-configuration switch >&2 || true


umount "$mountpoint"/proc
umount "$mountpoint"/dev
umount "$mountpoint"/sys
umount "$mountpoint"

if [ -n "$BASE_RESOURCE" ]; then
    grub-install "$device" >&2
fi

if [ -n "$volume" ]; then
    $ec2 detach-volume --volume-id "$volume" >&2

    date >&2
    snapshot=$($ec2 create-snapshot --volume-id "$volume" | jq -r .SnapshotId)
    echo now wait two years for: $snapshot >&2

    $ec2 create-tags --resources "$snapshot" --tags Key=ug-mkebs,Value="$toplevel" Key=Name,Value=mkebs-ami >&2

    progress=$($ec2 describe-snapshots --snapshot-ids "$snapshot" | jq -r '.Snapshots | .[] | .Progress')

    while [ "$progress" != "100%" ]; do
        echo creating snapshot: $progress >&2
        sleep 10
        progress=$($ec2 describe-snapshots --snapshot-ids "$snapshot" | jq -r '.Snapshots | .[] | .Progress')
    done

    while ! $ec2 describe-snapshots --snapshot-ids "$snapshot" | grep -q completed; do
        echo waiting for state "'completed'" >&2
        sleep 10
    done
    date >&2

    echo not deleting $volume >&2

    ami=$($ec2 register-image --architecture x86_64 --name "$aminame" \
         --root-device-name /dev/xvda \
         --block-device-mappings \
         "[{\"DeviceName\": \"/dev/xvda\",\"Ebs\":{\"SnapshotId\":\"$snapshot\"}}]" \
         --virtualization-type hvm | jq -r .ImageId)

    $ec2 create-tags --resources "$ami" --tags Key=ug-mkebs,Value="$toplevel" >&2
    echo $ami # only this gets printed to stdout
fi
