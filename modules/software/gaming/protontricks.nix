{gaming, ...}: {
  repository.features = [
    (gaming.nixos ({pkgs, ...}: {environment.systemPackages = [pkgs.protontricks];}))
  ];
}
