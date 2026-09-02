_: {
  repository.features = [
    {
      homeManager = {
        targets = ["gayming" "rwslaptop" "studio"];
        module = _: {
          programs.obsidian.enable = true;
        };
      };
    }
  ];
}
