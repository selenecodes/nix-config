_: {
  nixos.desktop = {pkgs, ...}: {
    xdg.portal = {
      enable = true;
      config.niri.default = ["gnome" "gtk"];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
