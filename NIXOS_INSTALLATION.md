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
For `rwslaptop`, it also encrypts the root filesystem with LUKS and prompts for a
disk-unlock passphrase. Store this passphrase safely: it is required at every
boot. If every configured LUKS passphrase is lost, the encrypted data cannot be
recovered. The EFI `/boot` partition remains unencrypted as required by UEFI.

## After first boot

```bash
mv /etc/nixos/nix-config ~/nix-config
nixos-rebuild switch --flake ~/nix-config#<host>
```

Replace `<host>` with the host that you installed. Commit the generated `hardware-configuration.nix` file after you move the repository.

## Physical security

`rwslaptop` uses LUKS full-disk encryption. Someone who boots another operating
system or resets account passwords cannot read the encrypted root filesystem
without its LUKS passphrase. This protection applies while the laptop is shut
down. Do not leave the laptop unlocked or suspended around untrusted people.

UEFI setup restrictions and Secure Boot are not required for this protection.
Secure Boot is useful if you need to defend against an attacker modifying the
boot chain and later capturing your LUKS passphrase. It is intentionally not
enabled here so corporate administrators retain their existing firmware access.

## Citrix Workspace

Citrix Workspace is disabled during installation because Citrix requires accepting
its EULA before downloading the Linux archive. Enable it after the first boot.

1. Open the [Citrix Workspace for Linux download page](https://www.citrix.com/downloads/workspace-app/betas-and-tech-previews/workspace-app-tp-gcc11-for-linux.html) in a browser, accept the EULA, and copy the archive download URL.
2. On the NixOS host, download the archive with the filename and hash expected by the pinned Nixpkgs revision:

   ```bash
   archive="$(nix eval --raw ~/nix-config#nixosConfigurations.rwslaptop.pkgs.citrix-workspace.src.name)"
   curl --fail --location --output "$archive" '<Citrix download URL>'
   # Or: wget --output-document="$archive" '<Citrix download URL>'
   nix-prefetch-url "file://$PWD/$archive"
   ```

3. Add this line to the `rwslaptop` module in `~/nix-config/modules/hosts/work-laptop.nix`:

   ```nix
   myConfig.citrix.enable = true;
   ```

4. Rebuild the system:

   ```bash
   nixos-rebuild switch --flake ~/nix-config#rwslaptop
   ```

Citrix may reject command-line requests without the browser-issued download URL; a
plain request to the page itself returns HTTP 403.

## DisplayLink

DisplayLink is also disabled during installation because its driver archive is
EULA-gated. After the first boot, register the archive and enable it:

```bash
archive="$(nix eval --raw ~/nix-config#nixosConfigurations.rwslaptop.pkgs.displaylink.src.name)"
nix-prefetch-url --name "$archive" 'https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip'
```

Add this line to `~/nix-config/modules/hosts/work-laptop.nix`, then rebuild:

```nix
myConfig.displaylink.enable = true;
```

```bash
nixos-rebuild switch --flake ~/nix-config#rwslaptop
```

If the vendor URL changes, download the archive after accepting the EULA from the
[DisplayLink Ubuntu driver page](https://www.synaptics.com/products/displaylink-usb-graphics-software-ubuntu-62), rename it to `$archive`, then run `nix-prefetch-url "file://$PWD/$archive"`.
