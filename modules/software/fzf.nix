_: {
  repository.features = [
    {
      homeManager = {
        targets = ["gayming" "rwslaptop" "studio"];
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
