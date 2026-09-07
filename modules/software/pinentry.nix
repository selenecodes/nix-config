_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.pinentry-qt];
        };
      };
      darwin = {
        targets = ["*"];
        module.homebrew.brews = ["pinentry-mac"];
      };
    }
  ];
}
