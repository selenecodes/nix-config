# Gayming NixOS installation

NixOS configuration for a gaming desktop with an NVIDIA RTX 5090, Hyprland, Caelestia, greetd with tuigreet, UWSM, and the Zen kernel.

See the [NixOS installation guide](../../../NIXOS_INSTALLATION.md). Disable Secure Boot and Fast Boot in BIOS or UEFI before you install this host.

## Checks after installation

- Check the Hyprland and Caelestia session with `systemctl --user status caelestia`.
- Confirm that the ASUS PA279 runs at 3840x2160 near 60 Hz and that Caelestia can change brightness over DDC or CI.
- Verify that browser screen sharing and file selection use the Hyprland and GTK portals.
- Run `nvidia-smi`. If it fails, check that Secure Boot is disabled.
- Start and unlock the 1Password SSH agent before Git signing.
