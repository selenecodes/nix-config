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
    }))
  ];
}
