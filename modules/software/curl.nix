_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.curl];
        };
      };
    }
  ];
}
