{
  commonNixosTargets,
  commonDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = commonNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.deadnix];};
      };
      darwin = {
        targets = commonDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.deadnix];};
      };
    }
  ];
}
