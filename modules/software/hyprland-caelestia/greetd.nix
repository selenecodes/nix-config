{hyprlandCaelestia, ...}: {
  repository.features = [
    (hyprlandCaelestia.nixos ({
      pkgs,
      lib,
      ...
    }: {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --time --cmd ${lib.escapeShellArg "${lib.getExe pkgs.uwsm} start -e -D Hyprland hyprland.desktop"}";
        };
      };

      # Unlock gnome-keyring when greetd starts the desktop session.
      security.pam.services.greetd.enableGnomeKeyring = true;
    }))
  ];
}
