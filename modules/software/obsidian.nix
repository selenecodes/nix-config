_: {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = _: {
          programs.obsidian.enable = true;
        };
      };
    }
  ];
}
