{ pkgs, ... }: {
  programs.aerospace = {
    enable = false;
    userSettings = {
      start-at-login = false;
    };
  };
}
