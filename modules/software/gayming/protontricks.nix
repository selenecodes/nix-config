{gaymingNixosTargets, ...}: {
  repository.features = [
    {
      nixos = {
        targets = gaymingNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.protontricks];};
      };
    }
  ];
}
