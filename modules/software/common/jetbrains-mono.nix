{common, ...}: {
  repository.features = [
    (common.system ({pkgs, ...}: {fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];}))
  ];
}
