{common, ...}: {
  repository.features = [
    (common.homeManager {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    })
  ];
}
