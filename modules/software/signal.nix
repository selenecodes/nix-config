_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.signal-desktop];
        };
      };
      darwin = {
        targets = ["*"];
        module.homebrew.casks = ["signal"];
      };
    }
  ];
}
