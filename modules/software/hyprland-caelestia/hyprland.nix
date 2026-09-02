{hyprlandCaelestia, ...}: {
  repository.features = [
    (hyprlandCaelestia.nixos (_: {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    }))
  ];
}
