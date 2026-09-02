_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module.homebrew.brews = ["gh"];
      };
    }
  ];
}
