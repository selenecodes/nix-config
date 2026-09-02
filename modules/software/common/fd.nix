{
  commonNixosTargets,
  commonDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = commonNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.fd];};
      };
      darwin = {
        targets = commonDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.fd];};
      };
    }
  ];
}
