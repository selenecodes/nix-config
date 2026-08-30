_: {
  nixos.work = {pkgs, ...}: {
    environment.systemPackages = [pkgs.displaylink];
    services.xserver.videoDrivers = ["displaylink" "modesetting"];
    systemd.services.dlm.wantedBy = ["multi-user.target"];
  };

  darwin.work = _: {
    homebrew.casks = ["displaylink"];
  };
}
