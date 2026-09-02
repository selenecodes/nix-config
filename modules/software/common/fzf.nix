{common, ...}: {
  repository.features = [
    (common.system ({pkgs, ...}: {environment.systemPackages = [pkgs.fzf];}))
    (common.homeManager {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    })
  ];
}
