_: {
  repository.features = [
    {
      homeManager = {
        targets = ["gayming" "rwslaptop"];
        module.programs.direnv = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    }
  ];
}
