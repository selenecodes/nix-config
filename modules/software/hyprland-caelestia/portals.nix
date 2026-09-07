{hyprlandCaelestia, ...}: {
  repository.features = [
    (hyprlandCaelestia.nixos (_: {
      xdg.portal = {
        enable = true;
        config.hyprland.default = ["hyprland" "gtk"];
      };
    }))
  ];
}
