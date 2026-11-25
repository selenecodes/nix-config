# Hyprland and Caelestia

This stack targets the NixOS outputs `gayming` and `rwslaptop`. Every stack unit must use the `hyprlandCaelestia` helper from `default.nix`; do not add a separate target list to a child module.

`hyprland.nix` enables Hyprland and UWSM. `greetd.nix` owns the tuigreet session and its Gnome Keyring PAM hook. `portals.nix` selects the Hyprland and GTK portal backends. `caelestia.nix` owns the shell, desktop applications, and session services. `theme.nix` owns generated-color settings, the upstream dots, the cursor, wallpaper seed, and the initialization service.

The integrations require the final enable option from their base feature. `integrations/neovim.nix` requires `programs.neovim.enable`, and `integrations/zsh.nix` requires `programs.zsh.enable`. Caelestia launches Zed via `zeditor`, but does not manage its theme.

The stack depends on the `caelestia-shell`, `caelestia-dots`, and `sweet-theme` flake inputs. `desktop/base.nix` provides generic desktop services, so it is not a dependency of this stack. Caelestia writes generated colors below `~/.config/hypr/scheme/` and application theme files; Home Manager does not own those generated files.

## Recursive import dependency

`flake.nix` uses `import-tree` to import every Nix module below `modules/`. This behavior imports `default.nix` beside the stack units. `default.nix` adds `hyprlandCaelestia` to `_module.args`, and each stack unit consumes that argument.

The `.interconnected` marker records that these files form one module boundary. Moving one stack unit outside this directory does not preserve that boundary, even though `import-tree` can still discover the file.

To remove the recursive import dependency, replace this directory with one aggregate module. The aggregate module must import every stack unit explicitly and supply their shared targets. Update the root importer so that only the aggregate module enters the module graph. Otherwise, `import-tree` will continue to discover each child independently. Keep the aggregate module and all stack units in one removal boundary.

Remove this directory only after removing the Caelestia inputs and all host-specific `caelestia/hypr-user.lua` additions. Existing VS Code extension data remains untouched by this configuration.
