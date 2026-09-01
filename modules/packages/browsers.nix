_: {
  nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [google-chrome firefox];
  };
  darwin.base = _: {
    homebrew.casks = ["arc"];
  };
}
