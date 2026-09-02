{work, ...}: {
  repository.features = [
    (work.system ({pkgs, ...}: {environment.systemPackages = [pkgs.libpq];}))
  ];
}
