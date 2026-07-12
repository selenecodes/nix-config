_: {
  nixos.wayland = _: {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    services.xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };
}
