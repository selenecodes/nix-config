_: {
  repository.features = [
    {
      homeManager = {
        targets = ["gayming" "rwslaptop" "studio"];
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
