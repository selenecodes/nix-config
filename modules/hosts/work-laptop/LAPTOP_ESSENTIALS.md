# Laptop essentials

Add these after the first NixOS boot. Check the installed hardware before enabling hardware-specific services.

## Start here

- Verify Caelestia's brightness, media, battery, lock, and power-profile controls on the installed hardware.
- Enable `fwupd`. Run `fwupdmgr get-updates` after installation and before changing firmware.

## Add after hardware checks

- Enable `bolt` only when the laptop uses Thunderbolt devices.
- Enable `fprintd` only after the fingerprint reader works with `fprintd-enroll`.
- Enable `thermald` on supported Intel hardware. Do not enable it on an AMD laptop without a reason.
- Configure the internal display, external displays, and dock after running `hyprctl monitors`.
- Add GPU, Wi-Fi, webcam, audio codec, and suspend fixes only when the generated hardware configuration or test results require them.

## Proprietary work software

Citrix Workspace and DisplayLink are disabled by default because their Linux packages require vendor archives. Follow the post-boot instructions in [`NIXOS_INSTALLATION.md`](../../../NIXOS_INSTALLATION.md) to register each archive and enable `myConfig.citrix.enable` or `myConfig.displaylink.enable`.

Test DisplayLink with the actual dock after enabling it. `rwslaptop` then starts `dlm` at boot, loads the `evdi` module through the NixOS DisplayLink module, and enables the `displaylink` and `modesetting` drivers. Add render-device overrides only when testing shows they are necessary.
