{ pkgs, ... }: {
  programs.git-cliff = {
    enable = true;
    settings = {
      header = "Changelog";
      trim = true;
    };
  };
}
