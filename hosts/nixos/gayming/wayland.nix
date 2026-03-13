{ pkgs, ... }:

{
  # Hyprland Wayland compositor with XWayland compatibility
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # SDDM display manager (Wayland mode)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha";
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "JetBrainsMono Nerd Font";
      fontSize = "14";
    })
  ];

  # Wayland / NVIDIA environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    # NVIDIA Wayland fixes
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    # Session hints
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # X server (provides XWayland + xkb config)
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
}
