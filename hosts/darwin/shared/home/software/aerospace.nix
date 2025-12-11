{ pkgs, ... }: {
  programs.aerospace = {
    enable = false;
    settings = {
      start-at-login = false;
    };
  };
}
