_: {
  nixos.wayland = _: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
