{common, ...}: {
  repository.features = [
    (common.homeManager (_: {
      programs.obsidian.enable = true;
    }))
  ];
}
