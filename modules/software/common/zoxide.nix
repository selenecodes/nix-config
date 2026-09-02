_: {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {
          programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
          };
        };
      };
    }
  ];
}
