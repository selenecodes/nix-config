_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module.homebrew.casks = ["cleanshot"];
      };
    }
  ];
}
