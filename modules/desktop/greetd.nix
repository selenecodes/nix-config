_: {
  nixos.wayland = {
    pkgs,
    lib,
    ...
  }: {
    services.greetd = {
      enable = true;
      # Compositor modules override default_session.command with --cmd <session>
      settings.default_session.command = lib.mkDefault "${pkgs.tuigreet}/bin/tuigreet --time";
    };
  };
}
