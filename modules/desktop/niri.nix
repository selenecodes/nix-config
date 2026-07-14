_: {
  nixos.wayland = {pkgs, ...}: {
    programs.niri.enable = true;

    services.greetd.settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'niri-session'";

    environment.sessionVariables = {
      XDG_SESSION_DESKTOP = "niri";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
