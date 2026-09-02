{
  commonNixosTargets,
  commonDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = commonNixosTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.fzf];};
      };
      darwin = {
        targets = commonDarwinTargets;
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.fzf];};
      };
    }
  ];
}
