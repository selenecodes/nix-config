#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# NixOS installer
# =============================================================================

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

FLAKE_URL="https://github.com/selenecodes/nix-config.git"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

info()    { echo -e "${GREEN}==>${RESET} ${BOLD}$*${RESET}"; }
warn()    { echo -e "${YELLOW}warn:${RESET} $*"; }
die()     { echo -e "${RED}error:${RESET} $*" >&2; exit 1; }

confirm() {
  local prompt="$1"
  local answer
  read -rp "$prompt [y/N] " answer
  [[ "${answer,,}" == "y" ]]
}

# -----------------------------------------------------------------------------
# Host selection
# -----------------------------------------------------------------------------

[[ $# -eq 1 ]] || die "usage: $0 <gayming|rwslaptop>"

case "$1" in
  gayming)
    HOST="gayming"
    HOST_DIRECTORY="gayming"
    ;;
  rwslaptop)
    HOST="rwslaptop"
    HOST_DIRECTORY="work-laptop"
    ;;
  *) die "unsupported host: $1 (expected gayming or rwslaptop)" ;;
esac

# -----------------------------------------------------------------------------
# Disk selection
# -----------------------------------------------------------------------------

echo
echo -e "${BOLD}Available disks:${RESET}"
echo
lsblk -d -o NAME,SIZE,MODEL | grep -v "loop"
echo

read -rp "Enter the disk to install on (e.g. nvme0n1, sda): " DISK_NAME
DISK="/dev/${DISK_NAME}"

[[ -b "$DISK" ]] || die "$DISK is not a block device"

DISK_INFO=$(lsblk -d -o SIZE,MODEL "$DISK" 2>/dev/null | tail -1)

# -----------------------------------------------------------------------------
# Confirmation - shown BEFORE anything destructive
# -----------------------------------------------------------------------------

echo
echo -e "${RED}${BOLD}WARNING: This will PERMANENTLY ERASE all data on:${RESET}"
echo -e "  ${BOLD}${DISK}${RESET}  ${DISK_INFO}"
echo
echo "The following will happen:"
echo "  1. GPT partition table written to ${DISK}"
echo "  2. EFI partition (512MB, FAT32, label: boot)"
echo "  3. Root partition (remainder, ext4, label: nixos)"
echo "  4. NixOS hardware config generated"
echo "  5. Repo cloned and hardware-configuration.nix replaced"
echo "  6. nixos-install --flake ${FLAKE_URL}#${HOST}"
echo

confirm "Are you absolutely sure you want to wipe ${DISK}?" || { echo "Aborted."; exit 0; }
confirm "Last chance - wipe ${DISK} and install NixOS?" || { echo "Aborted."; exit 0; }

# =============================================================================
# From here on: destructive actions
# =============================================================================

# Derive partition names (nvme uses p1/p2, sata uses 1/2)
if [[ "$DISK" == *"nvme"* || "$DISK" == *"mmcblk"* ]]; then
  PART_BOOT="${DISK}p1"
  PART_ROOT="${DISK}p2"
else
  PART_BOOT="${DISK}1"
  PART_ROOT="${DISK}2"
fi

# -----------------------------------------------------------------------------
# Partition
# -----------------------------------------------------------------------------

info "Partitioning ${DISK}..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB 512MB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary 512MB 100%

# Give the kernel a moment to register the new partitions
sleep 1
partprobe "$DISK"
sleep 1

# -----------------------------------------------------------------------------
# Format
# -----------------------------------------------------------------------------

info "Formatting partitions..."
mkfs.fat -F 32 -n boot "$PART_BOOT"
mkfs.ext4 -L nixos -F "$PART_ROOT"

# -----------------------------------------------------------------------------
# Mount
# -----------------------------------------------------------------------------

info "Mounting..."
mount "$PART_ROOT" /mnt
mkdir -p /mnt/boot
mount "$PART_BOOT" /mnt/boot

# -----------------------------------------------------------------------------
# Hardware config
# -----------------------------------------------------------------------------

info "Generating hardware configuration..."
nixos-generate-config --root /mnt

# -----------------------------------------------------------------------------
# Clone repo
# -----------------------------------------------------------------------------

info "Cloning config repo..."
nix-shell -p git --run "git clone ${FLAKE_URL} /mnt/etc/nixos/nix-config"

HARDWARE_CONFIG_DEST="/mnt/etc/nixos/nix-config/modules/hosts/${HOST_DIRECTORY}/hardware-configuration.nix"
[[ -d "$(dirname "$HARDWARE_CONFIG_DEST")" ]] || die "repository layout is missing $(dirname "$HARDWARE_CONFIG_DEST")"
info "Copying generated hardware-configuration.nix into repo..."
{
  printf '_: {\n  nixos.configurations.%s.module = ' "$HOST"
  cat /mnt/etc/nixos/hardware-configuration.nix
  printf ';\n}\n'
} > "$HARDWARE_CONFIG_DEST"

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------

info "Running nixos-install without setting a root password..."
nixos-install --flake /mnt/etc/nixos/nix-config#${HOST} --no-root-passwd

# -----------------------------------------------------------------------------
# User password - must be set before SDDM boots, otherwise you can't log in
# -----------------------------------------------------------------------------

info "Setting password for selene (you will be prompted)..."
nixos-enter --root /mnt -c "passwd selene"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo
echo -e "${GREEN}${BOLD}Installation complete.${RESET}"
echo
echo "Next steps after reboot:"
echo "  mv /etc/nixos/nix-config ~/nix-config              # move repo to home"
echo "  nixos-rebuild switch --flake ~/nix-config#${HOST}  # future rebuilds"
echo
warn "Remember to commit the real hardware-configuration.nix back to the repo."
echo
read -rp "Reboot now? [y/N] " answer
[[ "${answer,,}" == "y" ]] && reboot
