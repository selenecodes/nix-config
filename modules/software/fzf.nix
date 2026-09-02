_: {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {
          programs.fzf = {
            enable = true;
            enableZshIntegration = true;
          };
        };
      };
    }
  ];
}
