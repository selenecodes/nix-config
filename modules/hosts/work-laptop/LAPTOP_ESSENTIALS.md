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

Citrix Workspace and DisplayLink install with the work profile. Both Linux packages require a vendor archive that Nix cannot download automatically. For DisplayLink, run `nix-shell -p displaylink --arg config '{ allowUnfree = true; }'` and follow the printed instructions.

Test DisplayLink with the actual dock. `rwslaptop` starts `dlm` at boot, loads the `evdi` module through the NixOS DisplayLink module, and enables the `displaylink` and `modesetting` drivers. Add render-device overrides only when testing shows they are necessary.
