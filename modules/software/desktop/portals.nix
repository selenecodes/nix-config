_: {
  nixos.desktop = _: {
    xdg.portal = {
      enable = true;
      config.hyprland.default = ["hyprland" "gtk"];
    };
  };
}
