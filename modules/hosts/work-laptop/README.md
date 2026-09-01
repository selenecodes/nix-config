# rwslaptop installation

Run `install.sh` from the NixOS installer after you have backed up the target disk.

The script erases the selected disk, installs `rwslaptop`, and copies the generated hardware configuration into this directory. Commit that generated file after the first boot.

Citrix Workspace and DisplayLink install with the work profile. Before building either Linux package, register the required vendor archive in the Nix store.

For DisplayLink, run the following command and follow its instructions:

```bash
nix-shell -p displaylink --arg config '{ allowUnfree = true; }'
```

After logging into Hyprland, test the internal panel before connecting the DisplayLink dock. Then verify each dock output with `hyprctl monitors`; keep render-device overrides unset unless the tested hardware requires one.
