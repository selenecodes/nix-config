{common, ...}: {
  repository.features = [
    (common.system ({pkgs, ...}: {
      environment.systemPackages = [pkgs.gh];
    }))
  ];
}
