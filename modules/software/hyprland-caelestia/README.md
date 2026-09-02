# Hyprland and Caelestia

This stack targets the NixOS outputs `gayming` and `rwslaptop`. Every stack unit must use the `hyprlandCaelestia` helper from `default.nix`; do not add a separate target list to a child module.

`hyprland.nix` enables Hyprland and UWSM. `greetd.nix` owns the tuigreet session and its Gnome Keyring PAM hook. `portals.nix` selects the Hyprland and GTK portal backends. `caelestia.nix` owns the shell, desktop applications, and session services. `theme.nix` owns generated-color settings, the upstream dots, the cursor, wallpaper seed, and the initialization service.

The integrations require the final enable option from their base feature. `integrations/neovim.nix` requires `programs.neovim.enable`, `integrations/vscode.nix` requires `programs.vscode.enable`, and `integrations/zsh.nix` requires `programs.zsh.enable`. The VS Code integration uses its writable extension directory because Caelestia updates its generated theme.

The stack depends on the `caelestia-shell`, `caelestia-dots`, and `sweet-theme` flake inputs. `desktop/base.nix` provides generic desktop services, so it is not a dependency of this stack. Caelestia writes generated colors below `~/.config/hypr/scheme/` and application theme files; Home Manager does not own those generated files.

Remove this directory only after removing the Caelestia inputs and all host-specific `caelestia/hypr-user.lua` additions. Also remove `soramanew.caelestia-vscode-integration` manually from a writable VS Code extension directory if the VS Code integration is removed.
