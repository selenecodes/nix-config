{inputs, ...}: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module = {
          system = {
            configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
            stateVersion = 6;
          };

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
              extraFlags = ["--verbose"];
            };
            greedyCasks = true;
          };
        };
      };
    }
  ];
}
