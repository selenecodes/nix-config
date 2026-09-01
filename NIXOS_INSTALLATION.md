# NixOS installation guide

## Prerequisites

1. Back up the target disk.
2. Download the [NixOS minimal ISO](https://nixos.org/download) and flash it to a USB.

## Install

Boot the NixOS installer, then run:

```bash
sudo -i
nix-shell -p git
git clone https://github.com/selenecodes/nix-config.git
bash nix-config/install.sh <host>
```

Replace `<host>` with `gayming` or `rwslaptop`.

The script lists the available disks and requires two confirmations before it erases the selected disk.

## After first boot

```bash
mv /etc/nixos/nix-config ~/nix-config
nixos-rebuild switch --flake ~/nix-config#<host>
```

Replace `<host>` with the host that you installed. Commit the generated `hardware-configuration.nix` file after you move the repository.
