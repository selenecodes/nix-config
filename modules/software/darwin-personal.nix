_: {
  repository.features = [
    {
      darwin = {
        targets = ["studio"];
        module.homebrew.casks = [
          "cleanshot"
          "soundsource"
        ];
      };
    }
  ];
}
