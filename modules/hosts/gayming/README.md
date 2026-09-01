# Gayming: NixOS gaming desktop

NixOS configuration for a gaming desktop with an NVIDIA RTX 5090, Hyprland, Caelestia, greetd with tuigreet, UWSM, and the Zen kernel.

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
bash nix-config/modules/hosts/gayming/install.sh
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

- **Hyprland / Caelestia**. Greetd starts tuigreet, which launches the UWSM-managed Hyprland session. Check `systemctl --user status caelestia` after login.
- **Display**. Confirm the ASUS PA279 runs at 3840x2160 near 60 Hz and that Caelestia can change brightness over DDC/CI.
- **Portals**. Verify browser screen sharing and file selection use the Hyprland and GTK portals.
- **NVIDIA**. Run `nvidia-smi`. If it fails, check that Secure Boot is off.
- **1Password SSH agent**. Start and unlock it before Git signing works.
- **`hardware-configuration.nix`**. Commit the generated file so rebuilds use the installed machine's hardware configuration.
