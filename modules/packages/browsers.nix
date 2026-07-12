_: {
  nixos.personal = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [google-chrome firefox];
  };
  darwin.base = _: {
    homebrew.casks = ["arc"];
  };
}
