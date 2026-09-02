{
  commonNixosTargets,
  commonDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = commonNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.gnupg];};
      };
      darwin = {
        targets = commonDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.gnupg];};
      };
    }
  ];
}
