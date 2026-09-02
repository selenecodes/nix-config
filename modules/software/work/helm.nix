{
  workNixosTargets,
  workDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = workNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.kubernetes-helm];};
      };
      darwin = {
        targets = workDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.kubernetes-helm];};
      };
    }
  ];
}
