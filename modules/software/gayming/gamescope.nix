{gaymingNixosTargets, ...}: {
  repository.features = [
    {
      nixos = {
        targets = gaymingNixosTargets;
        module.programs.gamescope = {
          enable = true;
          capSysNice = true;
        };
      };
    }
  ];
}
