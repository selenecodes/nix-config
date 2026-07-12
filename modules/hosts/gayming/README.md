# Gayming — NixOS Gaming Desktop

NixOS configuration for a gaming desktop with NVIDIA RTX 5090, Hyprland (Wayland + XWayland), and Zen kernel.

## Installing on a Windows machine

### Prerequisites

1. Back up anything you want to keep
2. Disable **Secure Boot** in BIOS/UEFI (required for NVIDIA drivers) — also disable Fast Boot
3. Download the [NixOS minimal ISO](https://nixos.org/download) and flash it to a USB with Rufus or Balena Etcher

### Install

Boot from the USB, then run the install script:

```bash
sudo -i
nix-shell -p git
git clone https://github.com/selenecodes/nix-config.git
bash nix-config/hosts/nixos/gayming/install.sh
```

The script will show you exactly what it will do, ask for the target disk, and require **two confirmations** before touching anything.

### After First Boot

```bash
# Move the repo somewhere permanent
mv /etc/nixos/nix-config ~/nix-config

# All future rebuilds
nixos-rebuild switch --flake ~/nix-config#gayming
```

### Things to Check Post-Install

- **Hyprland / SDDM** — SDDM should launch automatically; if not run `systemctl start sddm`
- **NVIDIA** — verify with `nvidia-smi`; if it fails double-check Secure Boot is off
- **1Password SSH agent** — needs to be started and unlocked before git signing works
- **`hardware-configuration.nix`** — commit the real one back to the repo so rebuilds are reproducible
