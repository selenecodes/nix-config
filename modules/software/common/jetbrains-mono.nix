{
  commonNixosTargets,
  commonDarwinTargets,
  ...
}: {
  repository.features = [
    {
      nixos = {
        targets = commonNixosTargets;
        module = {pkgs, ...}: {fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];};
      };
      darwin = {
        targets = commonDarwinTargets;
        module = {pkgs, ...}: {fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];};
      };
    }
  ];
}
