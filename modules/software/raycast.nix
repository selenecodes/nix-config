_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.raycast];
        };
      };
    }
  ];
}
