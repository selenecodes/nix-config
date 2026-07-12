{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    grim
    slurp
    xwayland-satellite
    wf-recorder
    easyeffects
    nautilus
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  xdg.enable = true;
  services.network-manager-applet.enable = true;
}
