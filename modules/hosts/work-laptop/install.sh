#!/usr/bin/env bash
set -euo pipefail

flake_url="https://github.com/selenecodes/nix-config.git"
host="rwslaptop"
username="selene"

die() {
  printf '%s\n' "error: $*" >&2
  exit 1
}

confirm() {
  local answer
  read -r -p "${1} [y/N] " answer
  [[ "${answer,,}" == "y" ]]
}

lsblk -d -o NAME,SIZE,MODEL
read -r -p "Install NixOS to disk: " disk_name
disk="/dev/${disk_name}"
[[ -b "$disk" ]] || die "${disk} is not a block device"

printf '%s\n' "This erases ${disk}."
confirm "Erase ${disk}?" || exit 0
confirm "Last confirmation. Erase ${disk}?" || exit 0

if [[ "$disk" == *"nvme" || "$disk" == *"mmcblk" ]]; then
  boot_partition="${disk}p1"
  root_partition="${disk}p2"
else
  boot_partition="${disk}1"
  root_partition="${disk}2"
fi

parted "$disk" -- mklabel gpt
parted "$disk" -- mkpart ESP fat32 1MiB 512MiB
parted "$disk" -- set 1 esp on
parted "$disk" -- mkpart primary 512MiB 100%
partprobe "$disk"
sleep 1

mkfs.fat -F 32 -n boot "$boot_partition"
mkfs.ext4 -L nixos -F "$root_partition"
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt

nix-shell -p git --run "git clone ${flake_url} /mnt/etc/nixos/nix-config"
hardware_config="/mnt/etc/nixos/nix-config/modules/hosts/work-laptop/hardware-configuration.nix"
cp /mnt/etc/nixos/hardware-configuration.nix "$hardware_config"

nixos-install --flake /mnt/etc/nixos/nix-config#${host} --no-root-passwd
read -r -p "Account to set a password for [${username}]: " selected_username
username="${selected_username:-$username}"
nixos-enter --root /mnt -c "passwd ${username}"

printf '%s\n' "Installation complete. Commit the generated hardware configuration before rebuilding."
