{ pkgs, ... }: {
  programs.bun = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      telemetry = false;
      logLevel = "debug";
      test = {
        coverage = true;
        coverageThreshold = 0.9;
      };
    };
  };
}
