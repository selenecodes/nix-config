# GENERATED PLACEHOLDER — replace with output of:
#   nixos-generate-config --show-hardware-config
# or merge /etc/nixos/hardware-configuration.nix after first boot.
_: {
  nixos.configurations.gayming.module = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];

    # Update device paths / UUIDs after running nixos-generate-config
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };

    # fmask=0077/dmask=0077 restricts /boot to root-only (600/700), silencing
    # the bootctl random-seed security warning.
    # https://wiki.nixos.org/wiki/Bootloader
    # https://www.freedesktop.org/software/systemd/man/bootctl.html
    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
