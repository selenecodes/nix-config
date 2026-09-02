# Linux desktop

Both NixOS hosts run Hyprland through UWSM and use Caelestia as the desktop shell. Greetd and tuigreet provide the login screen.

## Configuration ownership

- `caelestia.nix` imports Caelestia's Home Manager module and manages shell settings, desktop tools, themes, and initialization.
- `hyprland.nix` enables the NixOS Hyprland and UWSM integration.
- The `caelestia-dots` flake input supplies the upstream Lua Hyprland configuration.
- The upstream Lua configuration starts Caelestia, clipboard history, Bluetooth MPRIS support, and login-time trash cleanup.
- `hypr-vars.lua` contains shared application and keybinding overrides.
- `hypr-user.lua` contains host-specific monitor configuration.

Caelestia writes generated colors to `~/.config/hypr/scheme/current.lua` and application theme files. Home Manager does not own those generated files.

The VS Code integration is installed into its writable extension directory because the extension updates its own generated theme. Remove `soramanew.caelestia-vscode-integration` manually if you later remove this configuration.

## First login

The `caelestia-initialize.service` selects the seeded wallpaper and the dynamic color scheme when no Caelestia scheme exists. Add more wallpapers to `~/Pictures/Wallpapers` without rebuilding NixOS.

Check the session after a rebuild:

```bash
caelestia shell -s
hyprctl monitors
```

Also test the lock screen, suspend, screen sharing, screenshots, recording, audio controls, and Bluetooth media keys. On `gayming`, test DDC brightness. On `rwslaptop`, test the internal panel and the DisplayLink dock.

Use the previous generation from the boot menu if the new graphical session cannot start. From a working terminal, run `just rollback` to switch to the previous generation.
