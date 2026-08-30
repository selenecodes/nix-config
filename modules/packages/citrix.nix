_: {
  nixos.work = {pkgs, ...}: {
    environment.systemPackages = [pkgs.citrix_workspace];
  };

  darwin.work = _: {
    homebrew.casks = ["citrix-workspace"];
  };
}
