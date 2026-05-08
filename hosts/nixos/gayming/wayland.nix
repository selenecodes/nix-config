{ pkgs, ... }:

{
  # Niri Wayland compositor
  programs.niri.enable = true;

  # greetd + tuigreet display manager
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'niri'";
  };

  # Wayland / NVIDIA environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    # NVIDIA Wayland fixes
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    # Session hints
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    XDG_CURRENT_DESKTOP = "niri";
  };

  # X server (provides XWayland + xkb config)
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
}
