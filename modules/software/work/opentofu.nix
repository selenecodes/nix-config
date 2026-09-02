{
  workNixosTargets,
  workDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = workNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.opentofu];};
      };
      darwin = {
        targets = workDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.opentofu];};
      };
    }
  ];
}
