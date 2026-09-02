{
  workNixosTargets,
  workDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = workNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.libpq];};
      };
      darwin = {
        targets = workDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.libpq];};
      };
    }
  ];
}
