{common, ...}: {
  repository.features = [
    (common.system ({pkgs, ...}: {environment.systemPackages = [pkgs.azure-cli];}))
  ];
}
