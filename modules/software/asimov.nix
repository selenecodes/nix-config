_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module.homebrew.brews = ["asimov"];
      };
    }
  ];
}
